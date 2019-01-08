import TLIndexPathTools

open class BaseCollectionView<TViewModel: BaseCollectionViewVM>: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TLIndexPathControllerDelegate {

	private var lastOffset = CGFloat(0.0)
	private let kDefaultReuseIdentifier = "kDefaultReuseIdentifier"

	public var viewModel: TViewModel {
		didSet {
			guard self.viewModel !== oldValue else { return }
			oldValue.indexpathController.delegate = nil
			self.viewModel.indexpathController.delegate = self
			self.viewModel.updateDataModel()
			self.viewModelChanged()
		}
	}
	public var isUpdateAnimated = false
	public var cellSize: CGSize = CGSize(width: 100, height: 100)
	public var forUpdatingAction: VoidBlock?

	private var identifierToCellMap = [ String: IHaveSize.Type ]()

	deinit {
		self.delegate = nil
		self.dataSource = nil
	}

	public init(collectionViewLayout: UICollectionViewLayout = UICollectionViewFlowLayout(),
				viewModel: TViewModel) {
		self.viewModel = viewModel
		super.init(frame: .zero, collectionViewLayout: collectionViewLayout)
		self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kDefaultReuseIdentifier)
		self.delegate = self
		self.dataSource = self
		self.viewModel.indexpathController.delegate = self
	}

	@available(*, unavailable)
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	open func viewModelChanged() {

	}

	public func registerXib(classes: [RegisterableClass]) {
		for regClass in classes {
			guard let cellClass = regClass as? UICollectionViewCell.Type else {
				assertionFailure("Can't register cell class \(String(describing: regClass))")
				continue
			}

			let identifier = regClass.identifier()
			if let nib = regClass.nib() {
				if let regClass = regClass as? IHaveSize.Type {
					self.identifierToCellMap[identifier] = regClass
				}
				self.register(nib, forCellWithReuseIdentifier: identifier)
			} else {
				self.register(cellClass, forCellWithReuseIdentifier: identifier)
			}
		}
	}

	open override func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
		if let cellClass = cellClass as? IHaveSize.Type {
			self.identifierToCellMap[identifier] = cellClass
		}
		super.register(cellClass, forCellWithReuseIdentifier: identifier)
	}

	// MARK: UITableViewDataSource

	open override var numberOfSections: Int {
		return self.viewModel.sectionsCount
	}

	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.viewModel.numberOfRows(in: section)
	}

	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let row = self.viewModel.item(at: indexPath)
		let reuseIdentifier: String = {
			guard let reuseIdentifier = row?.reuseIdentifier else {
				assertionFailure("you should register collection cell")
				return kDefaultReuseIdentifier
			}
			return reuseIdentifier
		}()
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
		if let cell = cell as? IHaveViewModel {
			cell.viewModelObject = row
		}
		return cell
	}

	// MARK: UITableViewDelegate

	public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		self.viewModel.didSelect(at: indexPath)
	}

	public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		if let cell = cell as? IHaveViewModel,
			let cellvm = cell.viewModelObject as? BaseCellVM {
			cellvm.appear()
		}
		self.checkIfCellIsMostVisible(cell: cell)
	}

	public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		if let cell = cell as? IHaveViewModel,
			let cellvm = cell.viewModelObject as? BaseCellVM {
			cellvm.disappear()
		}
	}

	// MARK: TLIndexPathControllerDelegate

	public func controller(_ controller: TLIndexPathController, didUpdateDataModel updates: TLIndexPathUpdates) {

		self.viewModel.isUpdating = true
		let completion = { [weak self] in
			guard let this = self else { return }

			this.forUpdatingAction?()
			this.viewModel.isUpdating = false
			this.viewModel.onTableUpdated?()
		}

		if self.isDecelerating || !self.isUpdateAnimated {
			self.reloadData()
			completion()
		} else {
			updates.performBatchUpdates(on: self, completion: { (finished) in
				completion()
			})
		}
	}

	// MARK: UICollectionViewDelegateFlowLayout

	open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		guard let vm = self.viewModel.item(at: indexPath),
			let cellClass = self.identifierToCellMap[vm.reuseIdentifier] else { return self.cellSize }

		return cellClass.internalSize(with: vm, size: collectionView.frame.size)
	}

	open func scrollViewDidScroll(_ scrollView: UIScrollView) {
		// Поскольку на экране показывается меньше ячеек, чем может быть на самом деле
		// (часть может находиться ниже экрана из-за особенностей работы панелей),
		// мы не можем полагаться только на механизм willDisplay cell,
		// поэтому делаем свой на основе скролла для проверки попадания видимых ячеек в область экрана
		if abs(self.contentOffset.x - self.lastOffset) > 5 {
			self.lastOffset = self.contentOffset.x
			self.processVisibleCellsInWindow()
		}
	}

	public func processVisibleCellsInWindow() {
		let visibleCells = self.visibleCells
		for cell in visibleCells {
			self.checkIfCellIsMostVisible(cell: cell)
		}
	}

	public func checkIfCellIsMostVisible(cell: UICollectionViewCell) {
		// 0.5 хардкодом, потому что сейчас все кейсы на треканье BSS показа завязаны на то, что
		// ячейка видна юзеру на 50%. Если в будущем эта логика будет разной, вынесем.
	}

}


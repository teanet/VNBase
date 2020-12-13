open class BaseTableView: UITableView {

	private static let kDefaultReuseIdentifier = "kDefaultReuseIdentifier"

	public let viewModel: BaseTableViewVM
	public var isUpdateAnimated = false
	public var shouldDeselectRowAutomatically = true
	public var updateAnimation = UITableView.RowAnimation.none {
		didSet {
			if #available(iOS 13.0, *) {
				self.diffableDataSource.defaultRowAnimation = self.updateAnimation
			}
		}
	}
	public var onScroll: ((BaseTableView) -> Void)?

	private var identifierToCellMap = [String: IHaveHeight.Type]()
	private var identifierToCellClassMap = [String: UITableViewCell.Type]()
	private var didSetup = false

	@available(iOS 13.0, *)
	private lazy var diffableDataSource: UITableViewDiffableDataSource<TableSectionVM, BaseCellVM> = {
		UITableViewDiffableDataSource<TableSectionVM, BaseCellVM>(
			tableView: self,
			cellProvider: { [weak self] (tv, indexPath, _) -> UITableViewCell? in
				guard let self = self else { return nil }

				let row = self.viewModel.item(at: indexPath)
				let reuseIdentifier = row?.reuseIdentifier ?? BaseTableView.kDefaultReuseIdentifier
				_ = self.cellClass(at: indexPath)
				let cell = tv.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
				if let cell = cell as? IHaveViewModel {
					cell.viewModelObject = row
				}
				if let vm = row {
					if vm.isSelected {
						tv.selectRow(at: indexPath, animated: false, scrollPosition: .none)
					} else {
						tv.deselectRow(at: indexPath, animated: false)
					}
				}
				return cell
			})
	}()

	deinit {
		self.delegate = nil
		self.dataSource = nil
	}

	public required init(style: UITableView.Style = .plain, viewModel: BaseTableViewVM) {
		self.viewModel = viewModel
		super.init(frame: .zero, style: style)
		self.register(UITableViewCell.self, forCellReuseIdentifier: BaseTableView.kDefaultReuseIdentifier)
		self.tableFooterView = UIView()
		self.estimatedRowHeight = 100
		self.estimatedSectionHeaderHeight = 40
		self.rowHeight = UITableView.automaticDimension
		self.cellLayoutMarginsFollowReadableWidth = false
		self.delegate = self
		self.allowsMultipleSelection = false
		self.viewModel.tableDelegate = self
	}

	@available(*, unavailable)
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	open func viewModelChanged() {
	}

	open override func didMoveToWindow() {
		super.didMoveToWindow()
		self.setupIfNeeded()
	}

	private func loadNextPageIfNeeded() {
		if self.indexPathsForVisibleRows?.contains(self.viewModel.indexPathToStartLoading) ?? false {
			self.autoLoadNextPage()
		}
	}

	private func autoLoadNextPage() {
		if self.viewModel.isAutoPrefetchEnabled {
			self.viewModel.loadNextPage()
		}
	}

	private func setupIfNeeded() {
		guard self.window != nil && !self.didSetup else { return }
		self.didSetup = true
		if #available(iOS 13.0, *) {
			self.diffableDataSource.defaultRowAnimation = self.updateAnimation
			self.diffableDataSource.apply(self.viewModel.sections.diffableDataSourceSnapshot(), animatingDifferences: false)
		} else {
			self.viewModel.indexpathController.delegate = self
			self.dataSource = self
		}
	}

	open override func register(_ aClass: AnyClass?, forHeaderFooterViewReuseIdentifier identifier: String) {
		if let headerClass = aClass as? IHaveHeight.Type {
			self.identifierToCellMap[identifier] = headerClass
		}
		super.register(aClass, forHeaderFooterViewReuseIdentifier: identifier)
	}

	open override func register(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
		if let cellClass = cellClass as? IHaveHeight.Type {
			self.identifierToCellMap[identifier] = cellClass
		}
		if let cellClass = cellClass as? UITableViewCell.Type {
			self.identifierToCellClassMap[identifier] = cellClass
		}
		super.register(cellClass, forCellReuseIdentifier: identifier)
	}

}

extension BaseTableView: UITableViewDataSource {

	public func numberOfSections(in tableView: UITableView) -> Int {
		return self.viewModel.sectionsCount
	}

	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.viewModel.numberOfRows(in: section)
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let row = self.viewModel.item(at: indexPath)

		let reuseIdentifier = row?.reuseIdentifier ?? BaseTableView.kDefaultReuseIdentifier
		_ = self.cellClass(at: indexPath)
		let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
		if let cell = cell as? IHaveViewModel {
			cell.viewModelObject = row
		}
		if let vm = row {
			if vm.isSelected {
				tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
			} else {
				tableView.deselectRow(at: indexPath, animated: false)
			}
		}
		return cell
	}

}

extension BaseTableView: UITableViewDelegate {

	open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.viewModel.didSelect(at: indexPath)
		if self.shouldDeselectRowAutomatically {
			self.viewModel.item(at: indexPath)?.deselect(animated: true)
		}
	}

	public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		self.viewModel.item(at: indexPath)?.deselect()
	}

	public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if let cell = cell as? IHaveViewModel,
			let cellvm = cell.viewModelObject as? BaseCellVM {
			cellvm.appear()
		}
		if indexPath == self.viewModel.indexPathToStartLoading {
			self.autoLoadNextPage()
		}
	}

	public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let headerVM = self.viewModel.section(at: section)?.header else { return nil }

		let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerVM.reuseIdentifier)
		if let header = header as? IHaveViewModel {
			header.viewModelObject = headerVM
		}
		return header
	}

	public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		let section = self.viewModel.section(at: section)
		if section?.title != nil { return UITableView.automaticDimension }
		guard let vm = section?.header,
			let headerClass = self.identifierToCellMap[vm.reuseIdentifier] else { return 0 }
		var width = tableView.frame.width
		if #available(iOS 11.0, *) {
			width -= (tableView.safeAreaInsets.left + tableView.safeAreaInsets.right)
		}
		return headerClass.internalHeight(with: vm, width: tableView.frame.width)
	}

	public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return self.viewModel.section(at: section)?.title
	}

	public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if let cell = cell as? IHaveViewModel,
			let cellvm = cell.viewModelObject as? BaseCellVM {
			cellvm.disappear()
		}
	}

	public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		guard let vm = self.viewModel.item(at: indexPath),
			  let cellClass = self.cellClass(at: indexPath) else { return UITableView.automaticDimension }
		var width = tableView.frame.width
		if #available(iOS 11.0, *) {
			width -= (tableView.safeAreaInsets.left + tableView.safeAreaInsets.right)
		}
		return cellClass.internalHeight(with: vm, width: tableView.frame.width)
	}

	private func cellClass(at indexPath: IndexPath) -> IHaveHeight.Type? {
		guard let vm = self.viewModel.item(at: indexPath) else { return nil }

		let reuseIdentifier = vm.reuseIdentifier
		if self.identifierToCellClassMap[reuseIdentifier] == nil {
			let registerableCell: IRegisterableCell? = vm
			if let cellClass = registerableCell?.cellClass?() {
				self.register(cellClass, forCellReuseIdentifier: reuseIdentifier)
			} else {
				assertionFailure("You should register cell")
				return nil
			}
		}
		let cellClass = self.identifierToCellMap[vm.reuseIdentifier]
		return cellClass
	}

	public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		guard let vm = self.viewModel.item(at: indexPath),
			  let cellClass = self.cellClass(at: indexPath) else { return 100 }
		return cellClass.internalEstimatedHeight(with: vm)
	}

	public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		let canEdit = self.viewModel.canEditRow(at: indexPath)
		return canEdit
	}

	public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let actions = self.viewModel.editingActions(for: indexPath)
		return actions
	}

	public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		let style = self.viewModel.editingStyle(for: indexPath)
		return style
	}

	public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		self.viewModel.commit(editingStyle: editingStyle, for: indexPath)
	}

	open func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {}
	open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {}
	open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {}
	open func scrollViewDidScroll(_ scrollView: UIScrollView) {
		self.onScroll?(self)
	}
}

extension BaseTableView: IndexPathControllerDelegate {

	func controller(_ controller: IndexPathController, didUpdateDataModel updates: IndexPathUpdates) {
		let block = { [weak self] in
			guard let self = self else { return }

			self.viewModel.isUpdating = false
			self.loadNextPageIfNeeded()
		}
		self.viewModel.isUpdating = true
		if self.isDecelerating || !self.isUpdateAnimated {
			self.reloadData()
			block()
		} else {
			updates.performBatchUpdates(on: self, animation: self.updateAnimation) { _ in
				block()
			}
		}
	}

}

extension BaseTableView: BaseTableViewVMDelegate {

	@available(iOS 13.0, *)
	func didChangeSnapshot(_ snapShot: NSDiffableDataSourceSnapshot<TableSectionVM, BaseCellVM>) {
		OperationQueue.main.addOperation {
			self.diffableDataSource.apply(
				snapShot,
				animatingDifferences: self.isUpdateAnimated) {}
		}
	}

	func tableViewVM(
		didChangeSelection isSelected: Bool,
		animated: Bool,
		scrollPosition: UITableView.ScrollPosition,
		at indexPath: IndexPath
	) {
		if isSelected {
			self.selectRow(at: indexPath, animated: animated, scrollPosition: scrollPosition)
		} else {
			self.deselectRow(at: indexPath, animated: animated)
		}
	}

}

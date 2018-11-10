import TLIndexPathTools

open class BaseTableView: UITableView, UITableViewDelegate, UITableViewDataSource, TLIndexPathControllerDelegate {

	private let kDefaultReuseIdentifier = "kDefaultReuseIdentifier"

	public var viewModel: BaseTableViewVM
	public var isUpdateAnimated = false
	public var updateAnimation = UITableView.RowAnimation.none

    private var identifierToCellMap = [String:IHaveHeight.Type]()

	deinit {
		self.delegate = nil
		self.dataSource = nil
	}

	public required init(style: UITableView.Style = .plain, viewModel: BaseTableViewVM) {
		self.viewModel = viewModel
		super.init(frame: .zero, style: style)
		self.register(UITableViewCell.self, forCellReuseIdentifier: kDefaultReuseIdentifier)
		self.tableFooterView = UIView()
		self.estimatedRowHeight = 100
		self.estimatedSectionHeaderHeight = 40
		self.rowHeight = UITableView.automaticDimension
		self.cellLayoutMarginsFollowReadableWidth = false
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
        super.register(cellClass, forCellReuseIdentifier: identifier)
    }

	// MARK: UITableViewDataSource

	public func numberOfSections(in tableView: UITableView) -> Int {
		return self.viewModel.sectionsCount
	}

	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.viewModel.numberOfRows(in: section)
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let row = self.viewModel.item(at: indexPath)

		let reuseIdentifier = row?.reuseIdentifier ?? kDefaultReuseIdentifier
		let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
		if let cell = cell as? IHaveViewModel {
			cell.viewModelObject = row
		}
		return cell
	}

	// MARK: UITableViewDelegate

	open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		self.viewModel.didSelect(at: indexPath)
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

	public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
	}

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let vm = self.viewModel.item(at: indexPath),
			let cellClass = self.identifierToCellMap[vm.reuseIdentifier] else { return UITableView.automaticDimension }
		var width = tableView.frame.width
		if #available(iOS 11.0, *) {
			width -= (tableView.safeAreaInsets.left + tableView.safeAreaInsets.right)
		}
        return cellClass.internalHeight(with: vm, width: tableView.frame.width)
    }

	public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		guard let vm = self.viewModel.item(at: indexPath),
			let cellClass = self.identifierToCellMap[vm.reuseIdentifier] else { return 100 }
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

	// MARK: TLIndexPathControllerDelegate

	public func controller(_ controller: TLIndexPathController, didUpdateDataModel updates: TLIndexPathUpdates) {

		let block = { [weak self] in
			guard let this = self else { return }

			this.viewModel.isUpdating = false
			this.loadNextPageIfNeeded()
		}

		if self.isDecelerating || !self.isUpdateAnimated {
			self.reloadData()
			block()
		} else {
			updates.performBatchUpdates(on: self, with: self.updateAnimation) { finished in
				block()
			}
		}
	}

}


import UIKit
import VNEssential

open class BaseTableView: UITableView {

	static let kDefaultReuseIdentifier = "kDefaultReuseIdentifier"

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

	private var didSetup = false

	@available(iOS 13.0, *)
	private var diffableDataSource: DiffableDataSource {
		self.diffableDataSourceAny as! DiffableDataSource
	}

	private lazy var diffableDataSourceAny: AnyObject? = {
		if #available(iOS 13.0, *) {
			return DiffableDataSource(
				table: self,
				tableVM: self.viewModel,
				dataSource: self.internalDataSource
			)
		} else {
			return nil
		}
	}()

	private lazy var internalDataSource = BaseDataSource(viewModel: self.viewModel)

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
		self.viewModel.onHeightChanged = { [weak self] in
			guard let self = self else { return }
			self.beginUpdates()
			self.endUpdates()
		}
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
			let snapshot = self.viewModel.sections.diffableDataSourceSnapshot()
			self.didChangeSnapshot(snapshot, animated: false)
		} else {
			self.viewModel.indexPathController.delegate = self
			self.dataSource = self.internalDataSource
		}
	}

	open override func register(_ aClass: AnyClass?, forHeaderFooterViewReuseIdentifier identifier: String) {
		if let headerClass = aClass as? IHaveHeight.Type {
			self.viewModel.identifierToCellMap[identifier] = headerClass
		}
		super.register(aClass, forHeaderFooterViewReuseIdentifier: identifier)
	}

	open override func register(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
		if let cellClass = cellClass as? IHaveHeight.Type {
			self.viewModel.identifierToCellMap[identifier] = cellClass
		}
		if let cellClass = cellClass as? UITableViewCell.Type {
			self.viewModel.identifierToCellClassMap[identifier] = cellClass
		}
		super.register(cellClass, forCellReuseIdentifier: identifier)
	}

	private func configureCell(at tv: UITableView, indexPath: IndexPath) -> UITableViewCell {
		let row = self.viewModel.item(at: indexPath)
		let reuseIdentifier = row?.reuseIdentifier ?? BaseTableView.kDefaultReuseIdentifier
		_ = self.viewModel.cellClass(at: indexPath)
		let cell = tv.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
		if let cell = cell as? IHaveViewModel {
			cell.viewModelObject = row
		}
		if let vm = row {
			let selectedRows = tv.indexPathsForSelectedRows ?? []
			if vm.isSelected, !selectedRows.contains(indexPath) {
				tv.selectRow(at: indexPath, animated: false, scrollPosition: .none)
			} else if !vm.isSelected && selectedRows.contains(indexPath) {
				tv.deselectRow(at: indexPath, animated: false)
			}
		}
		return cell
	}

}

extension BaseTableView: UITableViewDelegate {
	public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		let style = self.viewModel.editingStyle(for: indexPath)
		return style
	}

	public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let actions = self.viewModel.editingActions(for: indexPath)
		return actions
	}

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
			  let headerClass = self.viewModel.identifierToCellMap[vm.reuseIdentifier] else { return 0 }
		return headerClass.internalHeight(with: vm, width: tableView.frame.width)
	}

	public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if let cell = cell as? IHaveViewModel,
		   let cellvm = cell.viewModelObject as? BaseCellVM {
			cellvm.disappear()
		}
	}

	public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		guard let vm = self.viewModel.item(at: indexPath),
			  let cellClass = self.viewModel.cellClass(at: indexPath) else { return UITableView.automaticDimension }
		return cellClass.internalHeight(with: vm, width: tableView.frame.width)
	}

	public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		guard let vm = self.viewModel.item(at: indexPath),
			  let cellClass = self.viewModel.cellClass(at: indexPath) else { return 100 }
		return cellClass.internalEstimatedHeight(with: vm)
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
	func didChangeSnapshot(_ snapShot: NSDiffableDataSourceSnapshot<TableSectionVM, BaseCellVM>, animated: Bool?) {
		self.viewModel.isUpdating = true
		let animated = animated ?? self.isUpdateAnimated
		let completion: VoidBlock = {
			self.viewModel.isUpdating = false
		}
		if #available(iOS 15.0, *), !animated {
			self.diffableDataSource.applySnapshotUsingReloadData(snapShot, completion: completion)
		} else {
			let animatingDifferences = animated && !self.isDecelerating
			CATransaction.begin()
			CATransaction.setCompletionBlock(completion)
			self.diffableDataSource.apply(
				snapShot,
				animatingDifferences: animatingDifferences,
				completion: nil
			)
			CATransaction.commit()
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

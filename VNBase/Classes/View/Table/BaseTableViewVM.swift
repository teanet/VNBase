import Foundation

open class BaseTableViewVM: BaseVM {

	public var sections: [TableSectionVM] {
		didSet {
			if self.isUpdating {
				self.scheduledSections = self.sections
				self.sections = oldValue
			} else {
				oldValue.forEach {
					$0.onRowsChange = nil
					$0.rows.forEach { $0.tableDelegate = nil }
				}
				self.sections.forEach {
					$0.onRowsChange = {
						[weak self] in
						self?.updateDataModel()
					}
					$0.rows.forEach { $0.tableDelegate = self }
				}
				if let rows = self.sections.last?.rows {
					self.indexPathToStartLoading = IndexPath(
						row: max(rows.count - 3, 0),
						section: self.sections.count - 1
					)
				}
				self.updateDataModel()
			}

		}
	}

	public var rows: [BaseCellVM] {
		set {
			self.set(rows: newValue, addLoadingCell: true)
		}
		get {
			return self.sections.first?.rows ?? []
		}
	}

	public typealias ItemsCompletionBlock = ([BaseCellVM], Bool) -> Void
	public typealias PrefetchBlock = (_ reload: Bool, _ offset: Int, _ completion: @escaping ItemsCompletionBlock) -> Void
	public var isAutoPrefetchEnabled = false
	public var onSelect: ((BaseCellVM) -> Void)?
	public var onCommit: ((BaseCellVM, UITableViewCell.EditingStyle) -> Void)?

	public var shouldLoadNextPage = true
	public private(set) var isPrefetching = false

	private(set) var indexPathToStartLoading = IndexPath(row: 0, section: 0)
	var isUpdating = false {
		didSet {
			if !self.isUpdating, let scheduledSections = self.scheduledSections {
				self.scheduledSections = nil
				self.sections = scheduledSections
			}
		}
	}
	let indexpathController: IndexPathController
	weak var tableDelegate: BaseTableViewVMDelegate?
	public var prefetchBlock: PrefetchBlock?
	private let loadingRow: BaseCellVM?
	private var scheduledSections: [TableSectionVM]?

	public required init(sections: [TableSectionVM] = [], loadingRow: BaseCellVM? = nil) {
		self.dataModel = IndexPathModel(sections: sections)
		self.indexpathController = IndexPathController(dataModel: self.dataModel)
		self.loadingRow = loadingRow
		self.sections = sections
		super.init()
	}

	private var dataModel: IndexPathModel {
		didSet {
			if #available(iOS 13.0, *) {
				let snapshot = self.sections.diffableDataSourceSnapshot()
				self.tableDelegate?.didChangeSnapshot(snapshot)
			} else {
				self.indexpathController.dataModel = self.dataModel
			}
		}
	}

	public func loadNextPage(
		reload: Bool = false,
		shouldClearRowsOnReload: Bool = false,
		addLoadingCell: Bool = true
	) {
		guard let prefetchBlock = self.prefetchBlock else { return }

		if !reload && ( self.isPrefetching || !self.shouldLoadNextPage ) { return }

		self.isPrefetching = true

		let rows = self.rows.filter { $0 !== self.loadingRow }
		let offset = reload ? 0 : rows.count
		let reloadRows = shouldClearRowsOnReload ? [] : rows
		let prefix = reload ? [] : rows
		self.set(rows: reloadRows, addLoadingCell: addLoadingCell)

		prefetchBlock(reload, offset, { [weak self] items, finished in
			guard let this = self else { return }

			this.isPrefetching = false
			this.shouldLoadNextPage = !finished
			let rows = prefix + items
			let addLoadingCell = !finished
			this.set(rows: rows, addLoadingCell: addLoadingCell)
		})
	}

	public var sectionsCount: Int {
		self.dataModel.sections.count
	}

	public func numberOfRows(in sectionIndex: Int) -> Int {
		self.dataModel.numberOfItems(in: sectionIndex)
	}

	public func section(at index: Int) -> TableSectionVM? {
		self.sections.safeObject(at: index)
	}

	public func item(at indexPath: IndexPath) -> BaseCellVM? {
		self.dataModel.item(at: indexPath)
	}

	open func didSelect(at indexPath: IndexPath) {
		if let item = self.item(at: indexPath) {
			item.select()
			self.onSelect?(item)
		}
	}

	public func canEditRow(at indexPath: IndexPath) -> Bool {
		let item = self.item(at: indexPath)
		let canEdit = item?.isEditable

		return canEdit ?? false
	}

	public func editingActions(for indexPath: IndexPath) -> [UITableViewRowAction]? {
		let item = self.item(at: indexPath)
		let actions = item?.editingActions

		return actions
	}

	public func editingStyle(for indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		let item = self.item(at: indexPath)
		let style = item?.editingStyle

		return style ?? .none
	}

	public func commit(editingStyle: UITableViewCell.EditingStyle, for indexPath: IndexPath) {
		if let item = self.item(at: indexPath) {
			item.commit(editingStyle: editingStyle)
			self.onCommit?(item, editingStyle)
		}
	}

	open func move(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		let cellVM = self.sections[sourceIndexPath.section].rows.remove(at: sourceIndexPath.row)
		self.sections[destinationIndexPath.section].rows.insert(cellVM, at: destinationIndexPath.row)
	}

	private func set(rows: [BaseCellVM], addLoadingCell: Bool) {
		let section = self.sections.first ?? TableSectionVM()
		var newRows = rows

		if let loadingRow = self.loadingRow {
			if let index = rows.firstIndex(of: loadingRow) {
				newRows.remove(at: index)
			}
			if addLoadingCell {
				newRows.append(loadingRow)
			}
		}
		section.rows = newRows
		self.sections = [ section ]
	}

	private func updateDataModel() {
		self.dataModel = IndexPathModel(sections: self.sections)
	}

}

extension Array where Element: TableSectionVM {

	@available(iOS 13.0, *)
	func diffableDataSourceSnapshot() -> NSDiffableDataSourceSnapshot<TableSectionVM, BaseCellVM> {
		var snapshot = NSDiffableDataSourceSnapshot<TableSectionVM, BaseCellVM>()
		snapshot.appendSections(self)
		for section in self {
			snapshot.appendItems(section.rows, toSection: section)
		}
		return snapshot
	}

}

extension BaseTableViewVM: BaseCellVMTableDelegate {

	func cell(_ cell: BaseCellVM, didChangeSelection isSelected: Bool, animated: Bool, scrollPosition: UITableView.ScrollPosition) {

		guard let indexPath = self.dataModel.indexPaths(for: [cell]).first else {
			assertionFailure(""); return
		}
		self.tableDelegate?.tableViewVM(
			didChangeSelection: isSelected,
			animated: animated,
			scrollPosition: scrollPosition,
			at: indexPath
		)
	}

}

protocol BaseTableViewVMDelegate: AnyObject {

	func tableViewVM(
		didChangeSelection isSelected: Bool,
		animated: Bool,
		scrollPosition: UITableView.ScrollPosition,
		at indexPath: IndexPath
	)

	@available(iOS 13.0, *)
	func didChangeSnapshot(_ snapShot: NSDiffableDataSourceSnapshot<TableSectionVM, BaseCellVM>)

}

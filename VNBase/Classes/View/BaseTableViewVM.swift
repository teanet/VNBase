import Foundation

open class BaseTableViewVM: BaseVM {

	public var sections: [TableSectionVM] {
        willSet {
            self.sections.forEach { $0.onRowsChange = nil }
        }
		didSet {
            self.sections.forEach {
				$0.onRowsChange = {
					[weak self] in
					self?.updateDataModel()
				}
			}
			self.isUpdating = true
			if let rows = self.sections.last?.rows {
				self.indexPathToStartLoading = IndexPath(row: max(rows.count - 3, 0),
				                                         section: self.sections.count - 1)
			}
            self.updateDataModel()
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

	public typealias DidFetchItemsBlock = ((( @escaping ([BaseCellVM], Bool) -> Void)) -> Void)
	public var isAutoPrefetchEnabled = false
	public var onSelect: ((BaseCellVM) -> Void)?
	public var onCommit: ((BaseCellVM, UITableViewCell.EditingStyle) -> Void)? = nil

	public var shouldLoadNextPage = true
	public private(set) var isPrefetching = false

	private(set) var indexPathToStartLoading = IndexPath(row: 0, section: 0)
	var isUpdating = false
	let indexpathController: IndexPathController

	public var prefetchBlock: DidFetchItemsBlock? = nil
	private let loadingRow: BaseCellVM?

	public required init(sections: [TableSectionVM] = [], loadingRow: BaseCellVM? = nil) {
		self.dataModel = IndexPathModel(sections: sections)
		self.indexpathController = IndexPathController(dataModel: self.dataModel)
		self.loadingRow = loadingRow
		self.sections = sections
		super.init()
	}

	var dataModel: IndexPathModel {
		didSet {
			self.indexpathController.dataModel = self.dataModel
		}
	}

	public func loadNextPage(reload: Bool = false) {

		guard let prefetchBlock = self.prefetchBlock else { return }

		if !reload && ( self.isPrefetching || !self.shouldLoadNextPage ) { return }

		self.isPrefetching = true
		if (self.rows.isEmpty || reload) {
			self.set(rows: [], addLoadingCell: true)
		}

		prefetchBlock({ [weak self] items, finished in
			guard let this = self else { return }

			this.isPrefetching = false
			this.shouldLoadNextPage = !finished
			let rows = this.rows + items
			let addLoadingCell = !finished
			this.set(rows: rows, addLoadingCell: addLoadingCell)
		})
	}

	public var sectionsCount: Int {
		return self.dataModel.sections.count
	}

	public func numberOfRows(in sectionIndex: Int) -> Int {
		return self.dataModel.numberOfItems(in: sectionIndex)
	}

	public func section(at index: Int) -> TableSectionVM? {
		return self.sections.safeObject(at: index)
	}

	public func item(at indexPath: IndexPath) -> BaseCellVM? {
		return self.dataModel.item(at: indexPath)
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
		var rows = rows

		if let loadingRow = self.loadingRow {
			if let index = rows.firstIndex(of: loadingRow) {
				rows.remove(at: index)
			}
			if addLoadingCell {
				rows.append(loadingRow)
			}
		}
		section.rows = rows
		self.sections = [ section ]
	}

    private func updateDataModel() {
        self.dataModel = IndexPathModel(sections: self.sections)
    }

}

import TLIndexPathTools
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

	internal private(set) var indexPathToStartLoading = IndexPath(row: 0, section: 0)
	internal var isUpdating = false
	internal let indexpathController: TLIndexPathController

	public var prefetchBlock: DidFetchItemsBlock? = nil
	private let loadingRow: BaseCellVM?

	public required init(sections: [TableSectionVM] = [], loadingRow: BaseCellVM? = nil) {
		self.dataModel = TLIndexPathDataModel(sections: sections)
		self.indexpathController = TLIndexPathController()
		self.loadingRow = loadingRow
		self.sections = sections
		super.init()
	}

	internal var dataModel: TLIndexPathDataModel {
		didSet {
			self.indexpathController.dataModel = self.dataModel
		}
	}

	public func loadNextPage() {

		guard self.shouldLoadNextPage,
			let prefetchBlock = self.prefetchBlock,
			!self.isPrefetching else { return }

		self.isPrefetching = true

		if (self.rows.isEmpty) {
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

	internal var sectionsCount: Int {
		return self.dataModel.numberOfSections
	}

	public func numberOfRows(in sectionIndex: Int) -> Int {
		let numberOfRows = self.dataModel.numberOfRows(inSection: sectionIndex)
		return numberOfRows == NSNotFound ? 0 : numberOfRows
	}

	public func section(at index: Int) -> TableSectionVM? {
		return self.sections.safeObject(at: index)
	}

	public func item(at indexPath: IndexPath) -> BaseCellVM? {
		return self.dataModel.item(at: indexPath) as? BaseCellVM
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

	private func set(rows: [BaseCellVM], addLoadingCell: Bool) {
		let section = self.sections.first ?? TableSectionVM()
		var rows = rows

		if let loadingRow = self.loadingRow {
			if let index = rows.index(of: loadingRow) {
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
        self.dataModel = TLIndexPathDataModel(sections: self.sections)
    }

}

fileprivate extension TLIndexPathDataModel {

	fileprivate convenience init(sections: [TableSectionVM]) {
		let sectionInfos = sections.map { section -> TLIndexPathSectionInfo in
			return TLIndexPathSectionInfo(items: section.rows, name: section.uniqueIdentifier)
		}
		self.init(sectionInfos: sectionInfos, identifierKeyPath: #keyPath(BaseCellVM.uniqueIdentifier))
	}

}


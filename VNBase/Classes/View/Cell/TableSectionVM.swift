class TableSectionId: Id<String> {}

open class TableSectionVM: Equatable {

	public static func == (lhs: TableSectionVM, rhs: TableSectionVM) -> Bool {
		return lhs.uniqueIdentifier == rhs.uniqueIdentifier
	}

	public var rows: [BaseCellVM]
	public var title: String?
	public var footer: String?
	public let uniqueIdentifier: String
	let identifier: TableSectionId
	public var header: BaseHeaderViewVM?

	var onRowsChange: VoidBlock?

	public init(rows: [BaseCellVM] = [], header: BaseHeaderViewVM? = nil) {
		self.rows = rows
		self.header = header
		self.uniqueIdentifier = NSUUID().uuidString
		self.identifier = TableSectionId(self.uniqueIdentifier)
	}

	open func set(rows: [BaseCellVM], updateTableView: Bool) {
		self.rows = rows
		if updateTableView {
			self.onRowsChange?()
		}
	}

}

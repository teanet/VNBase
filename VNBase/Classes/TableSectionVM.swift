open class TableSectionVM: Equatable {

	public static func == (lhs: TableSectionVM, rhs: TableSectionVM) -> Bool {
		return lhs.uniqueIdentifier == rhs.uniqueIdentifier
	}

	public var rows: [BaseCellVM]
	public var title: String?
	public var footer: String?
	public let uniqueIdentifier: String
	public var header: BaseHeaderViewVM?

    internal var onRowsChange: VoidBlock?

	public init(rows: [BaseCellVM] = [], header: BaseHeaderViewVM? = nil) {
		self.rows = rows
		self.header = header
		self.uniqueIdentifier = NSUUID().uuidString
	}

    open func set(rows: [BaseCellVM], updateTableView: Bool) {
        self.rows = rows
        if updateTableView {
            self.onRowsChange?()
        }
    }

}



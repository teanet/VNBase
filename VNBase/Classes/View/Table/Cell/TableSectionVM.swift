import UIKit
import VNEssential

class TableSectionId: Id<String> {}

open class TableSectionVM: Equatable, Hashable {

	public static func == (lhs: TableSectionVM, rhs: TableSectionVM) -> Bool {
		return lhs.uniqueIdentifier == rhs.uniqueIdentifier
	}

	public var rows: [BaseCellVM]
	public var title: String?
	public var footer: String?
	public let uniqueIdentifier: String
	let identifier: TableSectionId
	public var header: BaseHeaderViewVM?
	weak var tableDelegate: BaseCellVMTableDelegate? {
		didSet {
			self.rows.forEach { $0.tableDelegate = self.tableDelegate }
		}
	}
	var onRowsChange: VoidBlock?

	public init(rows: [BaseCellVM] = [], header: BaseHeaderViewVM? = nil) {
		self.rows = rows
		self.header = header
		self.uniqueIdentifier = NSUUID().uuidString
		self.identifier = TableSectionId(self.uniqueIdentifier)
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.identifier)
	}

	open func set(rows: [BaseCellVM], updateTableView: Bool) {
		self.rows = rows
		rows.forEach {
			$0.tableDelegate = self.tableDelegate
		}
		if updateTableView {
			self.onRowsChange?()
		}
	}

}

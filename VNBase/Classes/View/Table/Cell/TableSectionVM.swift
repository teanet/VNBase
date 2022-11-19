import UIKit
import VNEssential

final class TableSectionId: Id<String> {}

open class TableSectionVM: Hashable, CustomDebugStringConvertible {

	public static func == (lhs: TableSectionVM, rhs: TableSectionVM) -> Bool {
		return lhs.uniqueIdentifier == rhs.uniqueIdentifier
	}

	public var rows: [BaseCellVM] {
		didSet {
			self.updateDelegates()
		}
	}
	public var title: String?
	public var footer: String?
	public let uniqueIdentifier: String
	let identifier: TableSectionId
	public var header: BaseHeaderViewVM?
	weak var tableDelegate: BaseCellVMTableDelegate? {
		didSet {
			self.updateDelegates()
		}
	}
	var onRowsChange: VoidBlock?

	public init(rows: [BaseCellVM] = [], header: BaseHeaderViewVM? = nil) {
		self.rows = rows
		self.header = header
		self.uniqueIdentifier = NSUUID().uuidString
		self.identifier = TableSectionId(self.uniqueIdentifier)
		self.updateDelegates()
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.uniqueIdentifier)
		hasher.combine(self.rows)
	}

	open func set(rows: [BaseCellVM], updateTableView: Bool) {
		self.rows = rows
		if updateTableView {
			self.onRowsChange?()
		}
	}

	open var debugDescription: String {
		"\(self.uniqueIdentifier): \(self.rows)"
	}

	private func updateDelegates() {
		self.rows.forEach { $0.tableDelegate = self.tableDelegate }
	}

}

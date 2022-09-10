import UIKit
import VNEssential

final class TableSectionId: Id<String> {}

open class TableSectionVM: Equatable, Hashable {

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
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.identifier)
	}

	open func set(rows: [BaseCellVM], updateTableView: Bool) {
		self.rows = rows
		if updateTableView {
			self.onRowsChange?()
		}
	}

	private func updateDelegates() {
		self.rows.forEach { $0.tableDelegate = self.tableDelegate }
	}

}

/**
Базовая вьюмодель ячейки.
Поддерживает основные события жизненного цикла ячейки.
*/

public class BaseCellId: Id<String> {}

open class BaseCellVM: BaseVM {

	public internal(set) var isVisible: Bool = false
	public internal(set) var isAppearedFirstTime: Bool = false

	public var isEditable: Bool = false
	public var editingActions: [UITableViewRowAction]?
	public static var reuseIdentifier: String {
		return NSStringFromClass(self)
	}	/**
	Уникальный идентификатор ячейки (разный для разных ячеек)
	*/
	public var reuseIdentifier: String {
		return type(of: self).reuseIdentifier
	}
	@objc public let uniqueIdentifier: String
	open var canMove: Bool { return false }
	open var editingStyle: UITableViewCell.EditingStyle { return .none }
	let identifier: BaseCellId
	internal private(set) var isSelected: Bool = false

	public override init() {
		self.uniqueIdentifier = UUID().uuidString
		self.identifier = BaseCellId(self.uniqueIdentifier)
		super.init()
	}

	/**
	Связано с событием скрола ячейки в списке.
	Может вызываться множество раз в течении жизненного цикла вьюмодели.
	*/
	open func appear() {
		if !self.isAppearedFirstTime {
			self.isAppearedFirstTime = true
			self.appearFirstTime()
		}
	}

	/**
	Связано с событием скрола ячейки в списке.
	Может вызываться множество раз в течении жизненного цикла вьюмодели.
	*/
	open func disappear() {
	}

	/**
	Связано с событием скрола ячейки в списке.
	Вызывается только один раз, когда ячейка первый раз становится видима на экране.
	*/
	open func appearFirstTime() {
	}

	open func select() {
		self.isSelected = true
	}

	open func deselect() {
		self.isSelected = false
	}

	open func commit(editingStyle: UITableViewCell.EditingStyle) {
	}

}

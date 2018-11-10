/**
Базовая вьюмодель ячейки.
Поддерживает основные события жизненного цикла ячейки.
*/
open class BaseCellVM: BaseVM {

	private var isAppearFirstTime = false
	public static var reuseIdentifier: String {
		return NSStringFromClass(self)
	}
	public internal(set) var isVisible: Bool = false
	public internal(set) var isAppearedFirstTime: Bool = false
	public internal(set) var isEditable: Bool = false
	public internal(set) var editingActions: [UITableViewRowAction]?
	public internal(set) var editingStyle: UITableViewCell.EditingStyle = .none
	/**
	Уникальный идентификатор ячейки (разный для разных ячеек)
	*/
	public var reuseIdentifier: String {
		return type(of: self).reuseIdentifier
	}
	@objc public let uniqueIdentifier: String

	public override init() {
		self.uniqueIdentifier = UUID().uuidString
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
	}

	open func commit(editingStyle: UITableViewCell.EditingStyle) {
	}

}

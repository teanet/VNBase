import UIKit
import VNEssential

/**
 Базовая вьюмодель ячейки.
 Поддерживает основные события жизненного цикла ячейки.
 */

public class BaseCellId: Id<String> {}

@objc public protocol IRegisterableCell: AnyObject {
	/// You can override it to return cell class, no need register cell then
	@objc optional func cellClass() -> UITableViewCell.Type
	@objc optional func collectionCellClass() -> UICollectionViewCell.Type
}

open class BaseCellVM: BaseVM, IRegisterableCell {

	public internal(set) var isVisible: Bool = false
	public internal(set) var isAppearedFirstTime: Bool = false
	public private(set) var isSelected: Bool = false

	public var isEditable: Bool = false
	public var editingActions: [UITableViewRowAction]?
	public static var reuseIdentifier: String { NSStringFromClass(self) }

	/**
	 Уникальный идентификатор ячейки (разный для разных ячеек)
	 */
	public var reuseIdentifier: String {
		return type(of: self).reuseIdentifier
	}
	@objc public let uniqueIdentifier: String
	open var canMove: Bool { return false }
	open var editingStyle: UITableViewCell.EditingStyle { .none }
	let identifier: BaseCellId
	weak var tableDelegate: BaseCellVMTableDelegate?
	weak var collectionDelegate: BaseCellVMCollectionDelegate?

	open override var hash: Int {
		var hasher = Hasher()
		hasher.combine(self.uniqueIdentifier)
		return hasher.finalize()
	}

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

	open func handleSelection(animated: Bool) {
	}

	open func handleDeselection(animated: Bool) {
	}

	open func handleSelection(isSelected: Bool, animated: Bool) {
	}

	public func select(
		animated: Bool = false,
		scrollPosition: UITableView.ScrollPosition = .none,
		collectionScrollPosition: UICollectionView.ScrollPosition = []
	) {
		if !self.isSelected {
			self.isSelected = true
			self.tableDelegate?.cell(self, didChangeSelection: true, animated: animated, scrollPosition: scrollPosition)
			self.collectionDelegate?.cell(self, didChangeSelection: true, animated: animated, scrollPosition: collectionScrollPosition)
			self.handleSelection(animated: animated)
			self.handleSelection(isSelected: true, animated: animated)
		}
	}

	public func deselect(animated: Bool = false) {
		if self.isSelected {
			self.isSelected = false
			self.tableDelegate?.cell(self, didChangeSelection: false, animated: animated, scrollPosition: .none)
			self.collectionDelegate?.cell(self, didChangeSelection: false, animated: animated, scrollPosition: [])
			self.handleDeselection(animated: animated)
			self.handleSelection(isSelected: false, animated: animated)
		}
	}

	open func commit(editingStyle: UITableViewCell.EditingStyle) {
	}

}

protocol BaseCellVMTableDelegate: AnyObject {

	func cell(
		_ cell: BaseCellVM,
		didChangeSelection isSelected: Bool,
		animated: Bool,
		scrollPosition: UITableView.ScrollPosition
	)

}

protocol BaseCellVMCollectionDelegate: AnyObject {

	func cell(
		_ cell: BaseCellVM,
		didChangeSelection isSelected: Bool,
		animated: Bool,
		scrollPosition: UICollectionView.ScrollPosition
	)

}

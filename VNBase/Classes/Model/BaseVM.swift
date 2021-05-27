import UIKit

open class BaseVM: NSObject {

	public enum ViewState {
		case other
		case hidden(Bool)
		case transparent(alpha: CGFloat)
	}

	// swiftlint:disable:next nsobject_prefer_isequal
	public static func == (lhs: BaseVM, rhs: BaseVM) -> Bool {
		return lhs === rhs
	}

	open var viewState: ViewState = .other {
		didSet {
			self.viewModelChanged()
		}
	}

	weak var didChangeDelegate: ViewModelChangedDelegate?

	/**
	Вызывается при изменении любого свойства вьюмодели.
	*/
	open func viewModelChanged() {
		self.didChangeDelegate?.viewModelChanged()
	}

}

import SnapKit
import UIKit

public extension ConstraintMakerPriortizable {

	@discardableResult
	func dgs_priority250() -> ConstraintMakerFinalizable {
		return self.priority(ConstraintPriority(floatLiteral: 250))
	}

	@discardableResult
	func dgs_priority749() -> ConstraintMakerFinalizable {
		return self.priority(ConstraintPriority(floatLiteral: 749))
	}

	@discardableResult
	func dgs_priority750() -> ConstraintMakerFinalizable {
		return self.priority(ConstraintPriority(floatLiteral: 750))
	}

	@discardableResult
	func dgs_priority751() -> ConstraintMakerFinalizable {
		return self.priority(ConstraintPriority(floatLiteral: 751))
	}

}

public extension UILayoutPriority {

	static var priority250: UILayoutPriority {
		return UILayoutPriority(250)
	}

	static var priority251: UILayoutPriority {
		return UILayoutPriority(251)
	}

	static var priority749: UILayoutPriority {
		return UILayoutPriority(749)
	}

	static var priority750: UILayoutPriority {
		return UILayoutPriority(750)
	}

	static var priority751: UILayoutPriority {
		return UILayoutPriority(751)
	}

}

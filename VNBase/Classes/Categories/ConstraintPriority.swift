import SnapKit
import UIKit

public extension ConstraintMakerPrioritizable {

	@discardableResult
	func dgs_priority250() -> ConstraintMakerFinalizable {
		self.priority(ConstraintPriority(floatLiteral: 250))
	}

	@discardableResult
	func dgs_priority749() -> ConstraintMakerFinalizable {
		self.priority(ConstraintPriority(floatLiteral: 749))
	}

	@discardableResult
	func dgs_priority750() -> ConstraintMakerFinalizable {
		self.priority(ConstraintPriority(floatLiteral: 750))
	}

	@discardableResult
	func dgs_priority751() -> ConstraintMakerFinalizable {
		self.priority(ConstraintPriority(floatLiteral: 751))
	}
	@discardableResult
	func dgs_priority999() -> ConstraintMakerFinalizable {
		self.priority(ConstraintPriority(floatLiteral: 999))
	}
}

public extension UILayoutPriority {

	static var priority250: UILayoutPriority { UILayoutPriority(250) }
	static var priority251: UILayoutPriority { UILayoutPriority(251) }
	static var priority749: UILayoutPriority { UILayoutPriority(749) }
	static var priority750: UILayoutPriority { UILayoutPriority(750) }
	static var priority751: UILayoutPriority { UILayoutPriority(751) }
	static var priority999: UILayoutPriority { UILayoutPriority(999) }

}

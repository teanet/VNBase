import SnapKit

public extension ConstraintMakerPriortizable {

	@discardableResult
	public func dgs_priority250() -> ConstraintMakerFinalizable {
		return self.priority(ConstraintPriority(floatLiteral: 250))
	}

	@discardableResult
	public func dgs_priority749() -> ConstraintMakerFinalizable {
		return self.priority(ConstraintPriority(floatLiteral: 749))
	}

	@discardableResult
	public func dgs_priority750() -> ConstraintMakerFinalizable {
		return self.priority(ConstraintPriority(floatLiteral: 750))
	}

	@discardableResult
	public func dgs_priority751() -> ConstraintMakerFinalizable {
		return self.priority(ConstraintPriority(floatLiteral: 751))
	}

}

public extension UILayoutPriority {

	public static var priority250: UILayoutPriority {
		return UILayoutPriority(250)
	}

	public static var priority251: UILayoutPriority {
		return UILayoutPriority(251)
	}

	public static var priority749: UILayoutPriority {
		return UILayoutPriority(749)
	}

	public static var priority750: UILayoutPriority {
		return UILayoutPriority(750)
	}

	public static var priority751: UILayoutPriority {
		return UILayoutPriority(751)
	}

}

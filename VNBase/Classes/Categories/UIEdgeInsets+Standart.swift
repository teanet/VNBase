import UIKit

public extension UIEdgeInsets {

	public static var dgs_invisibleSeparator: UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: 10000,
		                    bottom: 0, right: -10000)
	}

	public static var dgs_standartSeparator: UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
	}

	public static var dgs_standartControlTapArea: UIEdgeInsets {
		return UIEdgeInsets(top: -15, left: -15, bottom: -15, right: -15)
	}
}

import UIKit

public extension UIEdgeInsets {

	static var dgs_invisibleSeparator: UIEdgeInsets {
		UIEdgeInsets(
			top: 0, left: 10000, bottom: 0, right: -10000
		)
	}

	static var dgs_standartSeparator: UIEdgeInsets {
		UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
	}

	static var dgs_standartControlTapArea: UIEdgeInsets {
		UIEdgeInsets(top: -15, left: -15, bottom: -15, right: -15)
	}

	var horisontal: CGFloat {
		self.left + self.right
	}
	var vertical: CGFloat {
		self.top + self.bottom
	}
}

import UIKit

public enum UIMode {
	case day
	case night
}

public extension UITraitCollection {

	static var currentMode: UIMode {
		#if compiler(>=5.1)
		if #available(iOS 13.0, *) {
			return self.current.mode
		} else {
			return .night
		}
		#else
		return .night
		#endif
	}

	var mode: UIMode {
		if #available(iOS 12.0, *), self.userInterfaceStyle == .dark {
			return .night
		}
		return .day
	}

}

public extension UIColor {
	static func color(_ light: UIColor, dark: UIColor) -> UIColor {
		if #available(iOS 13.0, *) {
			return UIColor { $0.mode == .day ? light : dark }
		} else {
			return dark
		}
	}

	func cgColor(with traitCollection: UITraitCollection) -> CGColor {
		if #available(iOS 13.0, *) {
			return self.resolvedColor(with: traitCollection).cgColor
		} else {
			return self.cgColor
		}
	}
}

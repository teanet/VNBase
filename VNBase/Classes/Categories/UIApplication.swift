import UIKit

public extension UIApplication {
	static func keyWindow() -> UIWindow? {
		if #available(iOS 13.0, *) {
			return UIApplication.shared.connectedScenes
				.compactMap { $0 as? UIWindowScene }
				.flatMap { $0.windows }
				.filter { $0.isKeyWindow }
				.first
		} else {
			return UIApplication.shared.keyWindow
		}
	}
}

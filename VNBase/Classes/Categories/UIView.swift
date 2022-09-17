import UIKit
import SnapKit

public extension UIView {
	class func make(color: UIColor = .clear) -> UIView {
		let view = UIView()
		view.backgroundColor = color
		return view
	}

	var boundsCenter: CGPoint {
		self.bounds.boundsCenter
	}

	func addSubview(_ subview: UIView, withConstraints closure: (ConstraintMaker) -> Void) {
		subview.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(subview)
		subview.snp.makeConstraints(closure)
	}

	func findSubview(_ predicate: (UIView?) -> Bool) -> UIView? {
		if predicate(self) {
			return self
		}
		for child in self.subviews {
			if let result = child.findSubview(predicate) {
				return result
			}
		}
		return nil
	}

	func findSubview<T: UIView>(_ type: T.Type) -> T? {
		return self.findSubview { $0 is T } as? T
	}

	func setCornerRadius(_ radius: CGFloat, maskedCorners: CACornerMask? = nil) {
		self.layer.setCornerRadius(radius, maskedCorners: maskedCorners)
	}

}

public protocol Buildable {}
public extension Buildable where Self: NSObject {
	@discardableResult
	func with(_ closure: (Self) -> Void) -> Self {
		closure(self)
		return self
	}
}
extension UIView: Buildable {}
extension CALayer: Buildable {}

public extension CACornerMask {
	static let top: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
	static let bottom: CACornerMask = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
	static let left: CACornerMask = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
	static let right: CACornerMask = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
	static let all: CACornerMask = [
		.layerMinXMinYCorner,
		.layerMinXMaxYCorner,
		.layerMaxXMinYCorner,
		.layerMaxXMaxYCorner,
	]
}

public extension CALayer {

	func setCornerRadius(_ radius: CGFloat, maskedCorners: CACornerMask? = nil) {
		self.cornerRadius = radius
		self.masksToBounds = true
		if #available(iOS 11.0, *), let maskedCorners = maskedCorners {
			self.maskedCorners = maskedCorners
		}
	}

}

import UIKit
import SnapKit

public extension UIView {
	class func make(color: UIColor = .clear) -> UIView {
		let view = UIView()
		view.backgroundColor = color
		return view
	}

	func addSubview(_ subview: UIView, withConstraints closure: (_ make: ConstraintMaker) -> Void) {
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

	func setCornerRadius(_ radius: CGFloat) {
		self.layer.setCornerRadius(radius)
	}

}

public protocol Buildable {}
public extension Buildable where Self: UIView {
	@discardableResult
	func with(_ closure: (Self) -> Void) -> Self {
		closure(self)
		return self
	}
}
extension UIView: Buildable {}

public extension CALayer {

	func setCornerRadius(_ radius: CGFloat) {
		self.cornerRadius = radius
		self.masksToBounds = true
	}

}

import UIKit
import SnapKit

public extension UIView {

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

}

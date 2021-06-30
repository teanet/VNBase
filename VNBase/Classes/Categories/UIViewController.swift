import UIKit
import SnapKit

public extension UIViewController {

	var safeArea: UIEdgeInsets {
		if #available(iOS 11.0, *) {
			return self.view.safeAreaInsets
		} else {
			return .zero
		}
	}

	var viewHeight: CGFloat { self.view.bounds.height }

	func topVC() -> UIViewController {
		if let tabVC = self as? UITabBarController, let selectedViewController = tabVC.selectedViewController {
			return selectedViewController.topVC()
		} else if let navVC = self as? UINavigationController, let visibleViewController = navVC.visibleViewController {
			return visibleViewController.topVC()
		} else if let presentedVC = self.presentedViewController {
			return presentedVC.topVC()
		}
		return self
	}

	func topPresentedVC() -> UIViewController {
		if let presentedVC = self.presentedViewController {
			return presentedVC.topPresentedVC()
		}
		return self
	}

	func dgs_add(vc: UIViewController, view: UIView, closure: ((_ make: ConstraintMaker) -> Void)? = nil) {
		self.addChild(vc)
		vc.view.frame = view.bounds
		view.addSubview(vc.view)
		if let closure = closure {
			vc.view.snp.remakeConstraints(closure)
		} else {
			vc.view.snp.remakeConstraints({ (make) in
				make.edges.equalTo(view)
			})
		}
		vc.didMove(toParent: self)
	}

	func dgs_addBelow(vc: UIViewController, belowView: UIView, closure: ((_ make: ConstraintMaker) -> Void)? = nil) {
		self.addChild(vc)
		vc.view.frame = self.view.bounds
		self.view.insertSubview(vc.view, belowSubview: belowView)
		if let closure = closure {
			vc.view.snp.remakeConstraints(closure)
		} else {
			vc.view.snp.remakeConstraints({ (make) in
				make.edges.equalTo(view)
			})
		}
		vc.didMove(toParent: self)
	}

	func dgs_removeFromParent() {
		self.willMove(toParent: nil)
		if self.isViewLoaded {
			self.view.removeFromSuperview()
		}
		self.removeFromParent()
	}

	func setSwipeToBackEnabled(_ enabled: Bool) {
		guard self.parent === self.navigationController else { return }
		self.navigationController?.interactivePopGestureRecognizer?.isEnabled = enabled
		self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
	}

}

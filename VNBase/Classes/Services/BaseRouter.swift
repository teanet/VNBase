import UIKit
import VNEssential

public enum PushConfig {
	case push
	case replaceCurrent
	case popToRoot
}

open class BaseRouter: NSObject {

	public func showAlert(
		title: String? = nil,
		message: String? = nil,
		preferredStyle: UIAlertController.Style = .alert,
		preferredAction: UIAlertAction? = nil,
		actions: [UIAlertAction]
	) {
		let ac = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
		for action in actions {
			ac.addAction(action)
		}
		if let preferredAction = preferredAction {
			ac.preferredAction = preferredAction
		}
		self.present(ac)
	}

	open func present(
		_ vc: UIViewController,
		style: UIModalPresentationStyle = .fullScreen,
		animated: Bool = true,
		completion: VoidBlock? = nil
	) {
		vc.modalPresentationStyle = style
		guard let atVc = self.topPresentedVC() else {
			assertionFailure(); return
		}
		Thread.runOnMain {
			atVc.present(vc, animated: animated, completion: completion)
		}
	}

	open func dismiss(animated: Bool = true, _ completion: VoidBlock? = nil) {
		let topVC = self.topPresentedVC()
		if let presentingViewController = topVC?.presentingViewController {
			presentingViewController.dismiss(animated: animated, completion: completion)
		} else {
			completion?()
		}
	}

	public func topVC() -> UIViewController? {
		UIApplication.keyWindow()?.rootViewController?.topVC()
	}

	public func topPresentedVC() -> UIViewController? {
		UIApplication.keyWindow()?.rootViewController?.topPresentedVC()
	}
}

public extension UINavigationController {

	func push(
		_ vc: UIViewController,
		animated: Bool = true,
		config: PushConfig = .push,
		completion: VoidBlock? = nil
	) {
		switch config {
			case .push:
				self.pushViewController(vc, animated: animated, completion: completion)
			case .replaceCurrent:
				self._replaceCurrent(vc, animated: animated, completion: completion)
			case .popToRoot:
				self._popToRoot(vc, animated: animated, completion: completion)
		}
	}

	func pushViewController(_ viewController: UIViewController, animated: Bool, completion: VoidBlock?) {
		self.pushViewController(viewController, animated: animated)
		self.handleCompletion(animated: animated, completion: completion)
	}

	func setViewControllers(_ viewControllers: [UIViewController], animated: Bool, completion: VoidBlock?) {
		self.setViewControllers(viewControllers, animated: animated)
		self.handleCompletion(animated: animated, completion: completion)
	}

	func popViewController(animated: Bool, completion: VoidBlock?) {
		self.popViewController(animated: animated)
		self.handleCompletion(animated: animated, completion: completion)
	}

	func popToViewController(_ viewController: UIViewController, animated: Bool, completion: VoidBlock?) {
		self.popToViewController(viewController, animated: animated)
		self.handleCompletion(animated: animated, completion: completion)
	}

	private func handleCompletion(animated: Bool, completion: VoidBlock?) {
		guard animated, let coordinator = self.transitionCoordinator else {
			DispatchQueue.main.async {
				completion?()
			}
			return
		}
		coordinator.animate(alongsideTransition: nil) { _ in completion?() }
	}

	private func _replaceCurrent(_ vc: UIViewController, animated: Bool, completion: VoidBlock?) {
		var vcs = self.viewControllers
		if !vcs.isEmpty {
			vcs.removeLast()
		}
		vcs.append(vc)
		self.setViewControllers(vcs, animated: animated, completion: completion)
	}

	private func _popToRoot(_ vc: UIViewController, animated: Bool, completion: VoidBlock?) {
		var vcs = Array(self.viewControllers.prefix(1))
		vcs.append(vc)
		self.setViewControllers(vcs, animated: animated, completion: completion)
	}
}

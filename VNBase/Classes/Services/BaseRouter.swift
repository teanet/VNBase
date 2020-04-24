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

	public func present(
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

	public func dismiss(animated: Bool = true, _ completion: VoidBlock? = nil) {
		let topVC = self.topPresentedVC()
		if let presentingViewController = topVC?.presentingViewController {
			presentingViewController.dismiss(animated: animated, completion: completion)
		} else {
			completion?()
		}
	}

	// MARK: - Private

	private func topVC() -> UIViewController? {
		UIApplication.shared.keyWindow?.rootViewController?.topVC()
	}

	private func topPresentedVC() -> UIViewController? {
		UIApplication.shared.keyWindow?.rootViewController?.topPresentedVC()
	}
}

public extension UINavigationController {

	func push(_ vc: UIViewController, animated: Bool = true, config: PushConfig = .push) {
		switch config {
			case .push:
				self.pushViewController(vc, animated: animated)
			case .replaceCurrent:
				self._replaceCurrent(vc, animated: animated)
			case .popToRoot:
				self._popToRoot(vc, animated: animated)
		}
	}

	private func _replaceCurrent(_ vc: UIViewController, animated: Bool) {
		var vcs = self.viewControllers
		vcs.removeLast()
		vcs.append(vc)
		self.setViewControllers(vcs, animated: animated)
	}

	private func _popToRoot(_ vc: UIViewController, animated: Bool) {
		var vcs = Array(self.viewControllers.prefix(1))
		vcs.append(vc)
		self.setViewControllers(vcs, animated: animated)
	}

}

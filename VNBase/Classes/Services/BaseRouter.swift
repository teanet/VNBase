open class BaseRouter {

	public enum PushConfig {
		case push
		case replaceCurrent
		case popToRoot
	}

	open var nc: UINavigationController {
		fatalError("Override me please")
	}

	public func pop(animated: Bool = true) {
		self.nc.popViewController(animated: animated)
	}

	public func popToRoot(animated: Bool = true) {
		self.nc.popToRootViewController(animated: animated)
	}

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

	public func push(_ vc: UIViewController, animated: Bool = true, config: PushConfig = .push) {
		self.runOnMainThread { [weak self] in
			switch config {
				case .push:
					self?.nc.pushViewController(vc, animated: animated)
				case .replaceCurrent:
					self?._replaceCurrent(vc, animated: animated)
				case .popToRoot:
					self?._popToRoot(vc, animated: animated)
			}
		}
	}

	public func present(_ vc: UIViewController, animated: Bool = true, completion: VoidBlock? = nil) {
		self.runOnMainThread { [weak self] in
			self?.topVC()?.present(vc, animated: animated, completion: completion)
		}
	}

	//	MARK: - Private

	private func topVC() -> UIViewController? {
		UIApplication.shared.delegate?.window??.rootViewController?.topVC()
	}

	private func _replaceCurrent(_ vc: UIViewController, animated: Bool) {
		var vcs = self.nc.viewControllers
		vcs.removeLast()
		vcs.append(vc)
		self.nc.setViewControllers(vcs, animated: animated)
	}

	private func _popToRoot(_ vc: UIViewController, animated: Bool) {
		var vcs = Array(self.nc.viewControllers.prefix(1))
		vcs.append(vc)
		self.nc.setViewControllers(vcs, animated: animated)
	}

	private func runOnMainThread(block: @escaping VoidBlock) {
		if Thread.isMainThread {
			block()
		} else {
			assert(false, "Method should be called only on the Main Thread")
			DispatchQueue.main.async(execute: block)
		}
	}

}

import UIKit

open class BaseTransition: NSObject, UIViewControllerAnimatedTransitioning {

	public let operation: UINavigationController.Operation

	public init(operation: UINavigationController.Operation) {
		self.operation = operation

		super.init()
	}

	open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 0.3
	}

	open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

		guard let fromViewController = transitionContext.viewController(forKey: .from),
			let toViewController = transitionContext.viewController(forKey: .to)
		else {
			transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
			return
		}

		UIApplication.shared.beginIgnoringInteractionEvents()

		let containerView = transitionContext.containerView
		fromViewController.view.frame = transitionContext.initialFrame(for: fromViewController)
		fromViewController.view.layoutIfNeeded()
		if self.operation == .push {
			containerView.addSubview(toViewController.view)
		} else {
			containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
		}
		toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
		toViewController.view.layoutIfNeeded()
	}

	open func animationEnded(_ transitionCompleted: Bool) {
		UIApplication.shared.endIgnoringInteractionEvents()
	}

}

import UIKit

open class BaseNavigationController: UINavigationController {

	open override var childForStatusBarStyle: UIViewController? {
		self.topViewController
	}
	open override var childForStatusBarHidden: UIViewController? {
		self.topViewController
	}
	open override var shouldAutorotate: Bool {
		self.topViewController?.shouldAutorotate ?? false
	}
	open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		self.topViewController?.supportedInterfaceOrientations ?? .portrait
	}

}

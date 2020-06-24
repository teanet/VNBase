import UIKit

open class BaseTabBarController: UITabBarController, UITabBarControllerDelegate {

	open override var childForStatusBarStyle: UIViewController? {
		self.selectedViewController
	}
	open override var childForStatusBarHidden: UIViewController? {
		self.selectedViewController
	}
	open override var shouldAutorotate: Bool {
		self.selectedViewController?.shouldAutorotate ?? false
	}
	open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		self.selectedViewController?.supportedInterfaceOrientations ?? .portrait
	}

}

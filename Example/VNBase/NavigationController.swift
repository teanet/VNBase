import UIKit

class NavigationController: UINavigationController {

	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		self.topViewController?.supportedInterfaceOrientations ?? .portrait
	}

}

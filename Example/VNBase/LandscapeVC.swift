import VNBase

final class LandscapeVC: BaseVC<LandscapeVM> {

	override var navigationBarStyle: NavigationBarStyle? { .init() }
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .landscape }
	override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation { .landscapeRight }

	override func viewDidLoad() {
		super.viewDidLoad()
	}

}

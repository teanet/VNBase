import Foundation

open class BaseVC<TViewModel: BaseViewControllerVM> : UIViewController, ViewModelChangedDelegate {

	open override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
	open override var shouldAutorotate: Bool { true }
	open override var preferredStatusBarStyle: UIStatusBarStyle { .default }

	public let viewModel: TViewModel
	public private(set) lazy var refresh = UIRefreshControl()

	private var constraintsCreated = false

	deinit {
		self.viewModel.onLoading.remove(target: self)
	}

	public init(viewModel: TViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)

		viewModel.didChangeDelegate = self
		self.navigationItem.title = self.viewModel.title
	}

	@available(*, unavailable)
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	open override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white
		self.refresh.addTarget(self.viewModel, action: #selector(self.viewModel.reload), for: .valueChanged)
		self.viewModel.onLoading.add(self) { [weak self] (loading) in
			if loading {
				self?.refresh.beginRefreshing()
			} else {
				self?.refresh.endRefreshing()
			}
		}
		self.viewModel.load()
		self.viewModelChanged()
	}

	open override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.viewModel.appear()
		self.updateNavigationBarStyleIfNeeded()
		self.navigationController?.setNavigationBarHidden(self.navigationBarStyle == nil, animated: animated)

		assert(self.supportedInterfaceOrientations.contains(self.preferredInterfaceOrientationForPresentation.mask))

		if !self.supportedInterfaceOrientations.contains(UIApplication.shared.statusBarOrientation.mask) {
			UIDevice.current.rotate(
				to: self.supportedInterfaceOrientations,
				preferredInterfaceOrientation: self.preferredInterfaceOrientationForPresentation
			)
			UIViewController.attemptRotationToDeviceOrientation()
		}

	}

	open override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.viewModel.didAppear()
	}
	open override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.viewModel.disappear()
	}
	open override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		self.viewModel.didDisappear()
	}

	open override func updateViewConstraints() {
		if !self.constraintsCreated {
			self.createConstraints()
			self.constraintsCreated = true
		} else {
			self.updateConstraints()
		}

		super.updateViewConstraints()
	}

	open var navigationBarStyle: NavigationBarStyle? {
		assertionFailure("You should override this method")
		return nil
	}

	public func updateNavigationBarStyleIfNeeded() {
		// Защита от childviewcontrollers
		guard let nc = self.navigationController else { return }
		guard nc.viewControllers.contains(self) else { return }
		guard let style = self.navigationBarStyle else { return }

		nc.navigationBar.apply(style)
	}

	open func createConstraints() {}
	open func updateConstraints() {}
	open func viewModelChanged() {}

}

private extension UIInterfaceOrientation {

	var mask: UIInterfaceOrientationMask {
		switch self {
			case .unknown: return []
			case .portrait: return .portrait
			case .portraitUpsideDown: return .portraitUpsideDown
			case .landscapeLeft: return .landscapeLeft
			case .landscapeRight: return .landscapeRight
			@unknown default: return []
		}
	}

	var deviceOrientation: UIDeviceOrientation {
		switch self {
			case .unknown: return .unknown
			case .portrait: return .portrait
			case .portraitUpsideDown: return .portraitUpsideDown
			case .landscapeLeft: return .landscapeLeft
			case .landscapeRight: return .landscapeRight
			@unknown default: return .unknown
		}
	}

}

extension UIDeviceOrientation {

	func interfaceOrientation() -> UIInterfaceOrientation {
		switch self {
			case .portrait: return .portrait
			case .portraitUpsideDown: return .portraitUpsideDown
			case .landscapeLeft: return .landscapeLeft
			case .landscapeRight: return .landscapeRight
			case .unknown, .faceUp, .faceDown: return .unknown
			@unknown default: return .unknown
		}
	}

}

extension UIDevice {

	func rotate(
		to mask: UIInterfaceOrientationMask,
		preferredInterfaceOrientation: UIInterfaceOrientation
	) {
		let toInterfaceOrientation: UIInterfaceOrientation
		let realOrientation = self.orientation.interfaceOrientation()

		if self.orientation.isValidInterfaceOrientation && mask.contains(realOrientation.mask) {
			toInterfaceOrientation = realOrientation
		} else {
			toInterfaceOrientation = preferredInterfaceOrientation
		}

		self.setValue(
			toInterfaceOrientation.deviceOrientation.rawValue,
			forKey: NSStringFromSelector(#selector(getter: self.orientation))
		)
	}

}

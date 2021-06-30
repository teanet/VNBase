import UIKit

open class BaseVC<TViewModel: BaseViewControllerVM> : UIViewController, ViewModelChangedDelegate, IHaveViewModel {
	public var viewModelObject: BaseVM? {
		get { self.viewModel }
		set { _ = newValue }
	}

	open override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
	open override var shouldAutorotate: Bool { true }
	open override var preferredStatusBarStyle: UIStatusBarStyle { .default }

	public let viewModel: TViewModel
	public private(set) lazy var refresh: UIRefreshControl = {
		let refresh = UIRefreshControl()
		refresh.addTarget(self, action: #selector(self.onReload), for: .valueChanged)
		return refresh
	}()

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

		self.viewModel.onLoading.add(self) { [weak self] (loading) in
			guard let self = self else { return }
			if loading && !self.refresh.isRefreshing {
				self.refresh.beginRefreshing()
			} else if !loading && self.refresh.isRefreshing {
				self.refresh.endRefreshing()
			}
		}
		self.viewModel.load()
		self.viewModelChanged()
	}

	open override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.viewModel.appear()
		self.updateNavigationBarStyleIfNeeded()
		if self.parent === self.navigationController {
			self.navigationController?.setNavigationBarHidden(self.navigationBarStyle == nil, animated: animated)
		}

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
		let viewControllers = nc.viewControllers
		guard viewControllers.contains(where: { $0 === self }) else { return }
		guard let style = self.navigationBarStyle else { return }

		nc.navigationBar.apply(style)
	}

	open func createConstraints() {}
	open func updateConstraints() {}
	open func viewModelChanged() {}

	// MARK: - Private
	@objc private func onReload() {
		self.viewModel.reload()
	}

}

public extension UIInterfaceOrientation {

	internal var mask: UIInterfaceOrientationMask {
		switch self {
			case .unknown: return []
			case .portrait: return .portrait
			case .portraitUpsideDown: return .portraitUpsideDown
			case .landscapeLeft: return .landscapeLeft
			case .landscapeRight: return .landscapeRight
			@unknown default: return []
		}
	}

	func deviceOrientation() -> UIDeviceOrientation {
		return UIDeviceOrientation(rawValue: self.rawValue) ?? .unknown
	}

}

public extension UIDeviceOrientation {

	func interfaceOrientation() -> UIInterfaceOrientation {
		return UIInterfaceOrientation(rawValue: self.rawValue) ?? .unknown
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
			toInterfaceOrientation.deviceOrientation().rawValue,
			forKey: NSStringFromSelector(#selector(getter: self.orientation))
		)
	}

}

import Foundation

open class BaseVC<TViewModel: BaseViewControllerVM> : UIViewController, ViewModelChangedDelegate {

	open override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait }
	open var toInterfaceOrientation: UIInterfaceOrientation? { return .portrait }
	open override var shouldAutorotate: Bool { return true }
	open override var preferredStatusBarStyle: UIStatusBarStyle { return .default }

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
		if let toInterfaceOrientation = self.toInterfaceOrientation {
			UIDevice.current.setValue(toInterfaceOrientation.rawValue, forKey: "orientation")
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

	open func createConstraints() {

	}

	open func updateConstraints() {

	}

	open func viewModelChanged() {

	}

}

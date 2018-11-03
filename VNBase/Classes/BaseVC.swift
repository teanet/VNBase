import Foundation

open class BaseVC<TViewModel: BaseViewControllerVM> : UIViewController, ViewModelChangedDelegate {

	lazy var refresh = UIRefreshControl()

	public let viewModel: TViewModel
	open override var preferredStatusBarStyle: UIStatusBarStyle {
		return .default
	}

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
		self.viewModel.load()
		self.view.backgroundColor = .white
		self.refresh.addTarget(self.viewModel, action: #selector(self.viewModel.reload), for: .valueChanged)
		self.viewModel.onLoading.add(self) { [weak self] (loading) in
			if loading {
				self?.refresh.beginRefreshing()
			} else {
				self?.refresh.endRefreshing()
			}
		}
		self.viewModelChanged()
	}

	open override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.viewModel.appear()
	}

	open override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.viewModel.didAppear()
	}
	open override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.viewModel.disappear()
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

	open func createConstraints() {
		
	}

	open func updateConstraints() {

	}

	open func viewModelChanged() {
		
	}

}

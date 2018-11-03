open class BaseTableVC<TViewModel: BaseTableVM>: BaseVC<TViewModel> {

	public let tableView: BaseTableView
	public var clearsSelectionOnViewWillAppear = true

	public init(viewModel: TViewModel, style: UITableView.Style = .plain) {
		self.tableView = BaseTableView(style: style, viewModel: viewModel.tableVM)
		super.init(viewModel: viewModel)
	}

	public init(viewModel: TViewModel, tableView: BaseTableView) {
		self.tableView = tableView
		super.init(viewModel: viewModel)
	}

	open override func viewDidLoad() {
		super.viewDidLoad()

		self.tableView.frame = self.view.bounds
		self.tableView.autoresizingMask = [ .flexibleHeight, .flexibleWidth ]
		self.view.addSubview(self.tableView)
	}

	open override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if self.clearsSelectionOnViewWillAppear,
			let indexPath = self.tableView.indexPathForSelectedRow {
			self.tableView.deselectRow(at: indexPath, animated: animated)
		}
	}

}

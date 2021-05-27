import UIKit

open class BaseTableVC<TViewModel: BaseTableVM>: BaseVC<TViewModel> {

	open override var navigationBarStyle: NavigationBarStyle? { nil }
	public let tableView: BaseTableView
	public var clearsSelectionOnViewWillAppear = true

	private var toggleRefresh = false
	private var contentOffsetObservation: NSKeyValueObservation?

	deinit {
		self.contentOffsetObservation?.invalidate()
	}

	public init(viewModel: TViewModel, style: UITableView.Style = .plain) {
		self.tableView = BaseTableView(style: style, viewModel: viewModel.tableVM)
		super.init(viewModel: viewModel)
	}

	public init(viewModel: TViewModel, tableView: BaseTableView) {
		self.tableView = tableView
		super.init(viewModel: viewModel)
	}

	open override func loadView() {
		super.loadView()
		self.view.addSubview(self.tableView)
	}

	open override func viewDidLoad() {
		super.viewDidLoad()

		self.tableView.frame = self.view.bounds
		self.tableView.autoresizingMask = [ .flexibleHeight, .flexibleWidth ]
	}

	open override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if self.clearsSelectionOnViewWillAppear,
			let indexPath = self.tableView.indexPathForSelectedRow {
			self.tableView.viewModel.item(at: indexPath)?.deselect(animated: animated)
		}
	}

	public func setupRefreshControl() {
		self.tableView.refreshControl = self.refresh
		self.viewModel.onLoading.add(self) { [weak self] (loading) in
			guard let this = self else { return }

			var zeroOffset: CGFloat = 0
			if #available(iOS 11.0, *) {
				zeroOffset = this.tableView.contentInset.top - this.tableView.adjustedContentInset.top
			}
			if loading, this.tableView.contentOffset.y == zeroOffset {
				let offset = CGPoint(x: 0, y: -this.refresh.frame.height + zeroOffset)
				this.tableView.setContentOffset(offset, animated: true)
			}
		}
		let refresh = self.refresh
		self.contentOffsetObservation = self.tableView.observe(\.contentOffset) { [weak self] (tableView, _) in
			if tableView.contentOffset.y < -110, !refresh.isRefreshing, self?.toggleRefresh == false {
				self?.toggleRefresh = true
				refresh.beginRefreshing()
				self?.viewModel.reload()
			}
			if tableView.contentOffset.y >= 0 {
				self?.toggleRefresh = false
			}
		}
	}

}

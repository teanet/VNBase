import VNBase

internal final class TableDemoVC: BaseTableVC<TableDemoVM> {

	internal override func viewDidLoad() {
		super.viewDidLoad()
		self.setupRefreshControl()

		self.tableView.isUpdateAnimated = true
		self.tableView.register(cell: DemoCell.self)

		self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(self.add))
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "reload", style: .plain, target: self, action: #selector(self.reload))
	}

	@objc func add() {
		self.viewModel.addCell()
	}

	@objc func reload() {
		self.viewModel.reload()
	}

}

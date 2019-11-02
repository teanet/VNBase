import VNBase

final class TableDemoVC: BaseTableVC<TableDemoVM> {

	override var navigationBarStyle: NavigationBarStyle? { .init() }

	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupRefreshControl()

		self.tableView.isUpdateAnimated = true
		self.tableView.updateAnimation = .fade

		let segmentedControl = UISegmentedControl(items: self.viewModel.sections.enumerated().map({ "\($0.offset)" }))
		segmentedControl.addTarget(self, action: #selector(self.change(_:)), for: .valueChanged)
		self.navigationItem.titleView = segmentedControl

		self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(self.add))
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "reload", style: .plain, target: self, action: #selector(self.reload))
	}

	@objc func change(_ sc: UISegmentedControl) {
		let sections = self.viewModel.sections[sc.selectedSegmentIndex]
		self.viewModel.tableVM.sections = sections
	}

	@objc func add() {
		self.viewModel.addCell()
	}

	@objc func reload() {
		self.viewModel.reload()
	}

}

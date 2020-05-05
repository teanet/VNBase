import VNBase
import Foundation

final class TableDemoVC: BaseTableVC<TableDemoVM> {

	override var navigationBarStyle: NavigationBarStyle? { .init() }

	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupRefreshControl()

		self.tableView.isUpdateAnimated = true
		self.tableView.updateAnimation = .fade
		self.tableView.shouldDeselectRowAutomaticly = false
		self.tableView.allowsMultipleSelection = true

		let segmentedControl = UISegmentedControl(items: self.viewModel.sections.enumerated().map({ "\($0.offset)" }))
		segmentedControl.addTarget(self, action: #selector(self.change(_:)), for: .valueChanged)
		self.navigationItem.titleView = segmentedControl

		self.navigationItem.rightBarButtonItems = [
			UIBarButtonItem(title: "reload", style: .plain, target: self, action: #selector(self.reload)),
			UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(self.add)),
			UIBarButtonItem(title: "%", style: .plain, target: self, action: #selector(self.selectRandom)),
		]

	}

	@objc private func change(_ sc: UISegmentedControl) {
		let sections = self.viewModel.sections[sc.selectedSegmentIndex]
		self.viewModel.tableVM.sections = sections
	}

	@objc private func add() {
		self.viewModel.addCell()
	}

	@objc private func reload() {
		self.viewModel.reload()
	}

	@objc private func selectRandom() {
		self.viewModel.rows[Int.random(in: 0..<self.viewModel.rows.count)].select(
			animated: true,
			scrollPosition: .middle
		)
	}

}

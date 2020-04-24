import VNBase

final class DemoCell: BaseCell<DemoCellVM> {

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}

	override func viewModelChanged() {
		super.viewModelChanged()
		guard let vm = self.viewModel else { return }
		self.textLabel?.text = "Index: \(vm.index)"
	}

}

final class DemoCellVM: BaseCellVM {

	func cellClass() -> UITableViewCell.Type { DemoCell.self }
	let index: Int
	init(index: Int) {
		self.index = index
	}

}

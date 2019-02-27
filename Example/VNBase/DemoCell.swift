import VNBase

internal final class DemoCell: BaseCell<DemoCellVM> {

	internal override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

	}

	override func viewModelChanged() {
		super.viewModelChanged()
		guard let vm = self.viewModel else { return }
		self.textLabel?.text = "Index: \(vm.index)"
	}

}

internal final class DemoCellVM: BaseCellVM {

	let index: Int
	internal init(index: Int) {
		self.index = index
	}

}


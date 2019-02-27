import VNBase

internal final class TableDemoVM: BaseTableVM {

	init() {
		super.init(tableVM: BaseTableViewVM())
	}

	override func reload() {
		self.onLoading.raise(true)
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			self.onLoading.raise(false)
			self.tableVM.rows = []
		}
	}

	func addCell() {
		self.tableVM.rows.append(DemoCellVM(index: Int.random(in: 1...10000)))
	}

}

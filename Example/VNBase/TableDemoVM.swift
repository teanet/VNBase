import VNBase

final class TableDemoVM: BaseTableVM {

	let rows: [DemoCellVM]
	let sections: [[TableSectionVM]]
	init() {
		self.rows = stride(from: 0, to: 100, by: 1).map { DemoCellVM(index: $0) }
		self.sections = [
			[TableSectionVM(rows: [ self.rows[0], self.rows[1], self.rows[2], self.rows[3], self.rows[4] ])] ,
			[TableSectionVM(rows: [ self.rows[4], self.rows[3], self.rows[2], self.rows[1], self.rows[0] ])] ,
			[TableSectionVM(rows: [ self.rows[2], self.rows[3], self.rows[4], self.rows[5], self.rows[0] ])] ,
			[TableSectionVM(rows: [ self.rows[1], self.rows[2], self.rows[4], self.rows[5] ])] ,
			[TableSectionVM(rows: [])],
			[TableSectionVM(rows: self.rows)],
		]
		super.init(tableVM: BaseTableViewVM())
		self.rows[2].select()
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

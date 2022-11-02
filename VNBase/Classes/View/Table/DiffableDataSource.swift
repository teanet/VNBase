import UIKit

@available(iOS 13.0, *)
final class DiffableDataSource: UITableViewDiffableDataSource<TableSectionVM, BaseCellVM> {

	private let viewModel: BaseTableViewVM
	private let dataSource: BaseDataSource

	init(table: UITableView, tableVM: BaseTableViewVM, dataSource: BaseDataSource) {
		self.viewModel = tableVM
		self.dataSource = dataSource
		super.init(tableView: table) { tv, indexPath, _ in
			tableVM.configureCell(at: tv, indexPath: indexPath)
		}
	}

	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		self.dataSource.tableView(tableView, canEditRowAt: indexPath)
	}
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		self.dataSource.tableView(tableView, commit: editingStyle, forRowAt: indexPath)
	}
	override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		self.dataSource.tableView(tableView, canEditRowAt: indexPath)
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		self.dataSource.tableView(tableView, numberOfRowsInSection: section)
	}
	override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		self.dataSource.tableView(tableView, moveRowAt: sourceIndexPath, to: destinationIndexPath)
	}
	override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		self.dataSource.sectionIndexTitles(for: tableView)
	}
	override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
		self.dataSource.tableView(tableView, sectionForSectionIndexTitle: title, at: index)
	}
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		self.dataSource.tableView(tableView, titleForHeaderInSection: section)
	}
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		self.dataSource.tableView(tableView, titleForFooterInSection: section)
	}

}

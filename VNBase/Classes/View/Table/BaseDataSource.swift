import UIKit

final class BaseDataSource: NSObject, UITableViewDataSource {
	private let viewModel: BaseTableViewVM

	init(viewModel: BaseTableViewVM) {
		self.viewModel = viewModel
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		self.viewModel.sectionsCount
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		self.viewModel.numberOfRows(in: section)
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		self.viewModel.configureCell(at: tableView, indexPath: indexPath)
	}

	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		let canEdit = self.viewModel.canEditRow(at: indexPath)
		return canEdit
	}
	func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		self.viewModel.moveRowAt(sourceIndexPath: sourceIndexPath, to: destinationIndexPath)
	}
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		self.viewModel.commit(editingStyle: editingStyle, for: indexPath)
	}
	func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		self.viewModel.indexTitles
	}
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		self.viewModel.section(at: section)?.title
	}
	func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		self.viewModel.section(at: section)?.footer
	}

	func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
		tableView.scrollToRow(at: IndexPath(row: 0, section: index), at: .top , animated: false)
		if let sectionIndex = self.viewModel.indexTitles?.firstIndex(of: title) {
			return sectionIndex
		}
		return 0
	}

}

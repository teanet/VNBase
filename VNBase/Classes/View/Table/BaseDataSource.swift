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

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		self.viewModel.commit(editingStyle: editingStyle, for: indexPath)
	}
}

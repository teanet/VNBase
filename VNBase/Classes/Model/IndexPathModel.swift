import Foundation
import VNEssential

class IndexPathModel {

	struct Section {
		let id: TableSectionId
		let rows: [BaseCellVM]
	}

	let sections: [Section]
	let indexPathById: [BaseCellId: IndexPath]
	let idByindexPath: [IndexPath: BaseCellId]
	let itemsById: [BaseCellId: BaseCellVM]
	let items: [BaseCellVM]

	init(sections: [TableSectionVM]) {
		self.sections = sections.map({ Section.init(id: $0.identifier, rows: $0.rows) })
		var indexPathById = [BaseCellId: IndexPath]()
		var itemsById = [BaseCellId: BaseCellVM]()
		var idByindexPath = [IndexPath: BaseCellId]()
		var items = [BaseCellVM]()

		for section in 0..<sections.count {
			let sectionItem = sections[section]
			for row in 0..<sectionItem.rows.count {
				let item = sectionItem.rows[row]
				let indexPath = IndexPath(row: row, section: section)
				indexPathById[item.identifier] = indexPath
				idByindexPath[indexPath] = item.identifier
				itemsById[item.identifier] = item
				items.append(item)
			}
		}
		self.indexPathById = indexPathById
		self.idByindexPath = idByindexPath
		self.itemsById = itemsById
		self.items = items
	}

	var sectionIds: [TableSectionId] {
		return self.sections.map({ $0.id })
	}

	func currentVersion(of item: BaseCellVM?) -> BaseCellVM? {
		guard let item = item else { return nil }
		return self.itemsById[item.identifier]
	}

	func contains(item: BaseCellVM?) -> Bool {
		guard let item = item else { return false }
		return self.indexPathById[item.identifier] != nil
	}

	func indexPaths(for cells: [BaseCellVM]) -> [IndexPath] {
		return cells.compactMap { self.indexPathById[$0.identifier] }
	}

	func indexes(for ids: [TableSectionId]) -> IndexSet {
		var indexSet = IndexSet()
		for sectionId in ids {
			if let section = self.section(by: sectionId) {
				indexSet.insert(section)
			}
		}
		return indexSet
	}

	func sectionId(for item: BaseCellVM?) -> TableSectionId? {
		guard let item = item else { return nil }
		guard let indexPath = self.indexPathById[item.identifier] else { return nil }
		return self.sectionId(by: indexPath.section)
	}

	func section(by sectionId: TableSectionId) -> Int? {
		return self.sections.firstIndex { $0.id == sectionId }
	}

	func sectionId(by section: Int) -> TableSectionId? {
		return self.sections.safeObject(at: section)?.id
	}

	func numberOfItems(in section: Int) -> Int {
		if self.sections.isEmpty {
			return 0
		} else if self.sections.isIndexValid(index: section) {
			return self.sections[section].rows.count
		}
		assertionFailure("Invalid section index")
		return 0
	}

	func item(at indexPath: IndexPath) -> BaseCellVM? {
		guard let section = self.sections.safeObject(at: indexPath.section) else { return nil }
		return section.rows.safeObject(at: indexPath.row)
	}

}

import TLIndexPathTools

open class BaseCollectionViewVM: BaseVM {

	open var sections: [TableSectionVM] {
		willSet {
			self.sections.forEach {
				$0.onRowsChange = nil
			}
		}
		didSet {
			self.scheduledSections = self.sections
			if self.isUpdating {
				self.sections = oldValue
			} else {
				self.sections.forEach {
					$0.onRowsChange = {
						[weak self] in
						self?.updateDataModel()
					}
				}
				self.updateDataModel()
			}
		}
	}
	private var scheduledSections = [TableSectionVM]()

	open var items: [BaseCellVM] {
		set {
			self.set(items: newValue)
		}
		get {
			return self.sections.first?.rows ?? []
		}
	}

	public var onSelect: ((BaseCellVM) -> Void)?

	internal var isUpdating = false
	internal let indexpathController: TLIndexPathController
	internal var onTableUpdated: VoidBlock?

	private let loadingRow: BaseCellVM?

	public required init(sections: [TableSectionVM] = [], loadingRow: BaseCellVM? = nil) {
		self.dataModel = TLIndexPathDataModel(sections: sections)
		self.indexpathController = TLIndexPathController()
		self.loadingRow = loadingRow
		self.sections = sections
		super.init()
		self.onTableUpdated = { [weak self] in
			guard let this = self, this.sections != this.scheduledSections else { return }

			this.sections = this.scheduledSections
		}
	}

	internal var dataModel: TLIndexPathDataModel {
		didSet {
			self.indexpathController.dataModel = self.dataModel
		}
	}

	public var sectionsCount: Int {
		return self.dataModel.numberOfSections
	}

	public func numberOfRows(in sectionIndex: Int) -> Int {
		let numberOfRows = self.dataModel.numberOfRows(inSection: sectionIndex)
		return numberOfRows == NSNotFound ? 0 : numberOfRows
	}

	public func section(at index: Int) -> TableSectionVM? {
		return self.sections.safeObject(at: index)
	}

	public func item(at indexPath: IndexPath) -> BaseCellVM? {
		return self.dataModel.item(at: indexPath) as? BaseCellVM
	}

	open func didSelect(at indexPath: IndexPath) {
		if let item = self.item(at: indexPath) {
			item.select()
			self.onSelect?(item)
		}
	}

	public func updateDataModel() {
		self.dataModel = TLIndexPathDataModel(sections: self.sections)
	}

	private func set(items: [BaseCellVM]) {
		let section = self.sections.first ?? TableSectionVM()
		section.rows = items
		self.sections = [ section ]
	}

}

fileprivate extension TLIndexPathDataModel {

	fileprivate convenience init(sections: [TableSectionVM]) {
		let sectionInfos = sections.map { section -> TLIndexPathSectionInfo in
			return TLIndexPathSectionInfo(items: section.rows, name: section.uniqueIdentifier)
		}
		self.init(sectionInfos: sectionInfos, identifierKeyPath: #keyPath(BaseCellVM.uniqueIdentifier))
	}

}


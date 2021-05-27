import UIKit
import VNEssential

open class BaseCollectionViewVM: BaseVM {

	open var sections: [TableSectionVM] {
		willSet {
			self.sections.forEach {
				$0.onRowsChange = nil
				$0.rows.forEach { $0.collectionDelegate = nil }
			}
		}
		didSet {
			self.scheduledSections = self.sections
			if self.isUpdating {
				self.sections = oldValue
			} else {
				self.sections.forEach {
					$0.rows.forEach { $0.collectionDelegate = self }
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
		get {
			return self.sections.first?.rows ?? []
		}
		set {
			self.set(items: newValue)
		}
	}

	public var onSelect: ((BaseCellVM) -> Void)?

	var isUpdating = false
	let indexpathController: IndexPathController
	var onTableUpdated: VoidBlock?
	weak var collectionDelegate: BaseCollectionViewVMDelegate?
	private let loadingRow: BaseCellVM?

	public init(sections: [TableSectionVM] = [], loadingRow: BaseCellVM? = nil) {
		self.dataModel = IndexPathModel(sections: sections)
		self.indexpathController = IndexPathController(dataModel: self.dataModel)
		self.loadingRow = loadingRow
		self.sections = sections
		super.init()
		self.onTableUpdated = { [weak self] in
			guard let this = self, this.sections != this.scheduledSections else { return }

			this.sections = this.scheduledSections
		}
	}

	var dataModel: IndexPathModel {
		didSet {
			self.indexpathController.dataModel = self.dataModel
		}
	}

	public var sectionsCount: Int {
		return self.dataModel.sections.count
	}

	public func numberOfRows(in sectionIndex: Int) -> Int {
		return self.dataModel.numberOfItems(in: sectionIndex)
	}

	public func section(at index: Int) -> TableSectionVM? {
		return self.sections.safeObject(at: index)
	}

	public func item(at indexPath: IndexPath) -> BaseCellVM? {
		return self.dataModel.item(at: indexPath)
	}

	open func didSelect(at indexPath: IndexPath, animated: Bool = false) {
		if let item = self.item(at: indexPath) {
			item.select(animated: animated)
			self.onSelect?(item)
		}
	}

	open func didDeselect(at indexPath: IndexPath, animated: Bool = false) {
		if let item = self.item(at: indexPath) {
			item.deselect(animated: animated)
		}
	}

	public func updateDataModel() {
		self.dataModel = IndexPathModel(sections: self.sections)
	}

	private func set(items: [BaseCellVM]) {
		let section = self.sections.first ?? TableSectionVM()
		section.rows = items
		self.sections = [ section ]
	}

}

protocol BaseCollectionViewVMDelegate: AnyObject {

	func collectionView(
		didChangeSelection isSelected: Bool,
		animated: Bool,
		scrollPosition: UICollectionView.ScrollPosition,
		at indexPath: IndexPath
	)

}

extension BaseCollectionViewVM: BaseCellVMCollectionDelegate {

	func cell(
		_ cell: BaseCellVM,
		didChangeSelection isSelected: Bool,
		animated: Bool,
		scrollPosition: UICollectionView.ScrollPosition
	) {
		guard let indexPath = self.dataModel.indexPaths(for: [cell]).first else {
			assertionFailure(""); return
		}
		self.collectionDelegate?.collectionView(
			didChangeSelection: isSelected,
			animated: animated,
			scrollPosition: scrollPosition,
			at: indexPath
		)
	}

}

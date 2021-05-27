import UIKit
import VNEssential

class IndexPathUpdates {

	private let old: IndexPathModel?
	private let updated: IndexPathModel?
	let hasChanges: Bool
	let insertedSectionIds: [TableSectionId]
	let deletedSectionIds: [TableSectionId]
	let movedSectionIds: [TableSectionId]
	let insertedItems: [BaseCellVM]
	let deletedItems: [BaseCellVM]
	let movedItems: [BaseCellVM]
	let modifiedItems: [BaseCellVM]
	var updateModifiedItems: Bool = true

	init(old: IndexPathModel? = nil, updated: IndexPathModel? = nil) {
		self.old = old
		self.updated = updated

		var insertedSectionIds = [TableSectionId]()
		var deletedSectionIds = [TableSectionId]()
		var movedSectionIds = [TableSectionId]()
		var insertedItems = [BaseCellVM]()
		var deletedItems = [BaseCellVM]()
		var movedItems = [BaseCellVM]()
		var modifiedItems = [BaseCellVM]()

		let oldSectionNames = NSOrderedSet(array: old?.sectionIds ?? [])
		let updatedSectionNames = NSOrderedSet(array: updated?.sectionIds ?? [])
		let workingSectionNames = NSMutableOrderedSet(orderedSet: oldSectionNames)

		// Deleted sections
		for sectionId in oldSectionNames {
			if !updatedSectionNames.contains(sectionId) {
				// swiftlint:disable:next force_cast
				deletedSectionIds.append(sectionId as! TableSectionId)
				workingSectionNames.remove(sectionId)
			}
		}

		// Inserted sections
		var index = 0
		for sectionId in updatedSectionNames {
			if oldSectionNames.contains(sectionId) {
				let expectedIndex = workingSectionNames.index(of: sectionId)
				if index != expectedIndex {
					// only need to explicitly move sections that are misplaced
					// in the working set.
					// swiftlint:disable:next force_cast
					movedSectionIds.append(sectionId as! TableSectionId)
					workingSectionNames.remove(sectionId)
					workingSectionNames.insert(sectionId, at: index)
				}
			} else {
				// swiftlint:disable:next force_cast
				insertedSectionIds.append(sectionId as! TableSectionId)
				workingSectionNames.insert(sectionId, at: index)
			}
			index += 1
		}

		// Deleted and moved items
		if let old = old {
			for item in old.items {
				guard let oldIndexPath = old.indexPathById[item.identifier] else { continue }
				let sectionId = old.sectionId(by: oldIndexPath.section)

				if let updated = updated, updated.contains(item: item) {

					if let updatedIndexPath = updated.indexPathById[item.identifier] {

						let updatedSectionId = updated.sectionId(by: updatedIndexPath.section)
						// can't rely on isEqual, so must use compare
						let differentIndexPath = oldIndexPath.compare(updatedIndexPath) != .orderedSame
						if differentIndexPath || updatedSectionId != sectionId {
							// Don't move items in moved sections
							if !movedSectionIds.dgs_contains(sectionId) && differentIndexPath {
								movedItems.append(item)
							}
						}
					}
				} else {
					// Don't delete items in deleted sections
					if !deletedSectionIds.dgs_contains(sectionId) {
						deletedItems.append(item)
					}
				}
			}
		}

		if let updated = updated {

			for item in updated.items {

				if let oldItem = old?.currentVersion(of: item) {
					if oldItem.identifier != item.identifier {
						modifiedItems.append(item)
					}
				} else {
					let updatedIndexPath = updated.indexPathById[item.identifier]!
					let sectionId = updated.sectionId(by: updatedIndexPath.section)
					// Don't insert items in inserted sections
					if !insertedSectionIds.dgs_contains(sectionId) {
						insertedItems.append(item)
					}
				}
			}

		}

		self.hasChanges =
			movedSectionIds.count +
			insertedSectionIds.count +
			deletedSectionIds.count +
			movedItems.count +
			insertedItems.count +
			deletedItems.count +
			modifiedItems.count > 0
		self.insertedSectionIds = insertedSectionIds
		self.deletedSectionIds = deletedSectionIds
		self.movedSectionIds = movedSectionIds
		self.insertedItems = insertedItems
		self.deletedItems = deletedItems
		self.movedItems = movedItems
		self.modifiedItems = modifiedItems
	}

	func performBatchUpdates(on tableView: UITableView, animation: UITableView.RowAnimation, completion: BoolBlock?) {
		guard self.old != nil else {
			tableView.reloadData()
			completion?(true)
			return
		}

		CATransaction.begin()
		CATransaction.setCompletionBlock {
			if !self.modifiedItems.isEmpty && self.updateModifiedItems, let updated = self.updated {

				if let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows {
					let indexPaths = self.modifiedItems.compactMap({ updated.indexPathById[$0.identifier] })
					let visibleModifiedIndexPaths = indexPathsForVisibleRows.dgs_intersect(indexPaths)
					if !visibleModifiedIndexPaths.isEmpty {
						tableView.reloadRows(at: visibleModifiedIndexPaths, with: animation)
					}
				}

			}
			completion?(true)
		}

		tableView.beginUpdates()

		if !self.insertedSectionIds.isEmpty, let updated = self.updated {
			let insertedIndexes = updated.indexes(for: self.insertedSectionIds)
			tableView.insertSections(insertedIndexes, with: animation)
		}

		if !self.deletedSectionIds.isEmpty, let old = self.old {
			let deletedIndexes = old.indexes(for: self.deletedSectionIds)
			tableView.deleteSections(deletedIndexes, with: animation)
		}

		if !self.insertedItems.isEmpty, let updated = self.updated {
			let inserted = updated.indexPaths(for: self.insertedItems)
			tableView.insertRows(at: inserted, with: animation)
		}

		if !self.deletedItems.isEmpty, let old = self.old {
			let deleted = old.indexPaths(for: self.deletedItems)
			tableView.deleteRows(at: deleted, with: animation)
		}

		for moved in self.movedItems {
			let oldIndexPath = self.old?.indexPathById[moved.identifier]
			let updatedIndexPath = self.updated?.indexPathById[moved.identifier]

			let oldSectionId = self.old?.sectionId(for: moved)
			let updatedSectionId = self.updated?.sectionId(for: moved)

			let oldSectionDeleted = self.deletedSectionIds.dgs_contains(oldSectionId)
			let updatedSectionInserted = self.insertedSectionIds.dgs_contains(updatedSectionId)
			// `UITableView` doesn't support moving an item out of a deleted section
			// or moving an item into an inserted section. So we use inserts and/or deletes
			// as a workaround. A better workaround can be employed in client code by
			// by using empty sections to ensure all sections exist at all times, which
			// generally results in a better looking animation. When using `TLIndexPathControlelr`,
			// a good place to implement this workaround is in the `willUpdateDataModel`
			// delegate method by taking the incoming data model and inserting missing sections
			// with empty instances of `TLIndexPathSectionInfo`.
			if oldSectionDeleted && updatedSectionInserted {
				// don't need to do anything
			} else if oldSectionDeleted {
				if let updatedIndexPath = updatedIndexPath {
					tableView.insertRows(at: [ updatedIndexPath ], with: animation)
				}
			} else if updatedSectionInserted {
				if let oldIndexPath = oldIndexPath {
					tableView.deleteRows(at: [ oldIndexPath ], with: animation)
				}
				if let updatedIndexPath = updatedIndexPath {
					tableView.insertRows(at: [ updatedIndexPath ], with: animation)
				}
			} else {
				if let oldIndexPath = oldIndexPath, let updatedIndexPath = updatedIndexPath {
					tableView.moveRow(at: oldIndexPath, to: updatedIndexPath)
				}
			}
		}

		tableView.endUpdates()
		CATransaction.commit()
	}

	func performBatchUpdates(on collectionView: UICollectionView, completion: BoolBlock?) {
		guard ( self.old?.items.isEmpty == false ) && ( self.updated?.items.isEmpty == false ) else {
			completion?(true)
			return
		}

		// TODO this entire block of code seems to be unnecessary as of iOS 6.1.3 (it is
		// here to work around a crash on the first batch update when the collection view is
		// starting with zero items). Need to do more testing before removing.
		if self.old?.items.isEmpty == true {
			collectionView.reloadData()
			// asking the collection view how many items it has in each section
			// resolves a bug where the collection view can sometimes be confused
			// about the number of items it has after reloadData, leading to an
			// internal inconsistency exception on subsequent batch updates. (The scenario
			// that this fixed for me was when the first insert had only 1 item. On the next
			// insert, however many items were being inserted, the collection view thought
			// it already had that many items, causing the next insert to crash.)
			for i in 0..<collectionView.numberOfSections {
				collectionView.numberOfItems(inSection: i)
			}
			completion?(true)
			return
		}

		collectionView.performBatchUpdates({

			if !self.insertedSectionIds.isEmpty, let updated = self.updated {
				let inserted = updated.indexes(for: self.insertedSectionIds)
				collectionView.insertSections(inserted)
			}

			if !self.deletedSectionIds.isEmpty, let old = self.old {
				let deleted = old.indexes(for: self.deletedSectionIds)
				collectionView.deleteSections(deleted)
			}

			if !self.movedSectionIds.isEmpty, let updated = self.updated, let old = self.old {
				for sectionId in self.movedSectionIds {
					if let oldSection = old.section(by: sectionId), let updatedSection = updated.section(by: sectionId) {
						collectionView.moveSection(oldSection, toSection: updatedSection)
					}
				}
			}

			if !self.insertedItems.isEmpty, let updated = self.updated {
				let indexPaths = updated.indexPaths(for: self.insertedItems)
				collectionView.insertItems(at: indexPaths)
			}

			if !self.deletedItems.isEmpty, let old = self.old {
				let indexPaths = old.indexPaths(for: self.deletedItems)
				collectionView.deleteItems(at: indexPaths)
			}

			for item in self.modifiedItems {
				let oldIndexPath = self.old?.indexPathById[item.identifier]
				let updatedIndexPath = self.updated?.indexPathById[item.identifier]

				let oldSectionId = self.old?.sectionId(for: item)
				let updatedSectionId = self.updated?.sectionId(for: item)

				let oldSectionDeleted = self.deletedSectionIds.dgs_contains(oldSectionId)
				let updatedSectionInserted = self.insertedSectionIds.dgs_contains(updatedSectionId)
				// `UICollectionView` doesn't support moving an item out of a deleted section
				// or moving an item into an inserted section. So we use inserts and/or deletes
				// as a workaround. A better workaround can be employed in client code by
				// by using empty sections to ensure all sections exist at all times, which
				// generally results in a better looking animation. When using `TLIndexPathControlelr`,
				// a good place to implement this workaround is in the `willUpdateDataModel`
				// delegate method by taking the incoming data model and inserting missing sections
				// with empty instances of `TLIndexPathSectionInfo`.
				if oldSectionDeleted && updatedSectionInserted {
					// don't need to do anything
				} else if oldSectionDeleted {
					if let updatedIndexPath = updatedIndexPath {
						collectionView.insertItems(at: [ updatedIndexPath ])
					}
				} else if updatedSectionInserted {
					if let oldIndexPath = oldIndexPath {
						collectionView.deleteItems(at: [ oldIndexPath ])
					}
					if let updatedIndexPath = updatedIndexPath {
						collectionView.insertItems(at: [ updatedIndexPath ])
					}
				} else {
					if let oldIndexPath = oldIndexPath, let updatedIndexPath = updatedIndexPath {
						collectionView.moveItem(at: oldIndexPath, to: updatedIndexPath)
					}
				}
			}
		}, completion: { (finished) in

			// Doing this in the batch updates can result in poor looking animation when
			// an item is moving and reloading at the same time. The resulting animation
			// can show to versions of the cell, one version remains in the original spot
			// and fades out, while the other version slides to the new location.
			if !self.modifiedItems.isEmpty && self.updateModifiedItems, let updated = self.updated {
				let indexPaths = updated.indexPaths(for: self.modifiedItems)
				collectionView.reloadItems(at: indexPaths)
			}

			completion?(finished)
		})
	}

}

extension Array where Element: Hashable {

	func dgs_intersect(_ array: [Element]) -> [Element] {
		var set = Set(self)
		set.formIntersection(array)
		return Array(set)
	}

}

extension Array where Element: Equatable {

	func dgs_contains(_ element: Element?) -> Bool {
		guard let element = element else { return false }
		return self.contains(element)
	}

}

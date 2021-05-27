import Foundation

class IndexPathController {

	var dataModel: IndexPathModel? {
		didSet {
			// data model may get set multiple times during batch udpates,
			// so make sure we remember the initial old data model (which will
			// get cleared in `performUpdates` when the batch updates complete).
			if self.oldDataModel == nil {
				self.oldDataModel = oldValue
			}
			self.needsUpdate = true
			self.dequeuePendingUpdates()
		}
	}
	weak var delegate: IndexPathControllerDelegate?
	private var oldDataModel: IndexPathModel?
	private var needsUpdate: Bool = false

	init(dataModel: IndexPathModel?) {
		self.dataModel = dataModel
	}

	private func dequeuePendingUpdates() {
		guard self.needsUpdate else { return }

		let updates = IndexPathUpdates(old: self.oldDataModel, updated: self.dataModel)
		self.needsUpdate = false
		self.delegate?.controller(self, didUpdateDataModel: updates)
		self.oldDataModel = nil
	}

}

protocol IndexPathControllerDelegate: AnyObject {

	func controller(_ controller: IndexPathController, didUpdateDataModel updates: IndexPathUpdates)

}

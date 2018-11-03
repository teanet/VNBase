struct PushMessage {

	enum Action: String {
		case other
		case requestPermission = "request_permission"
	}

	private struct C {
		static let aps = "aps"
		static let alert = "alert"
		static let title = "title"
		static let body = "body"
		static let badge = "badge"
		static let action = "action"
		static let itemId = "item_id"
	}
	private let data: [AnyHashable : Any]
	let title: String?
	let aps: [AnyHashable : Any]?
	let message: String?
	let action: Action
	let itemId: Int?

	init(push: [AnyHashable : Any]) {
		self.data = push
		self.aps = push[C.aps] as? [AnyHashable : Any]
		if let alert = self.aps?[C.alert] as? String {
			self.title = alert
			self.message = nil
		} else if let alert = self.aps?[C.alert] as? [AnyHashable : String] {
			self.title = alert[C.title]
			self.message = alert[C.body]
		} else {
			self.title = nil
			self.message = nil
		}
		if let action = push[C.action] as? String {
			self.action = Action(rawValue: action) ?? .other
		} else {
			self.action = .other
		}
		self.itemId = push[C.itemId] as? Int
	}

}


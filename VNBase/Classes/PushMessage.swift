public struct PushMessage {

	public enum Action: String {
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
	public let title: String?
	public let aps: [AnyHashable : Any]?
	public let message: String?
	public let action: Action
	public let itemId: Int?

	public init(push: [AnyHashable : Any]) {
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


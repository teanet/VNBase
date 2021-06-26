import UIKit

public struct PushMessage {

	public enum C {
		static let aps = "aps"
		static let alert = "alert"
		static let title = "title"
		static let body = "body"
		static let badge = "badge"
	}
	public let data: [AnyHashable : Any]
	public let title: String?
	public let aps: [AnyHashable : Any]?
	public let message: String?

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
	}

}

public extension UNNotificationResponse {
	func message() -> PushMessage {
		return self.notification.message()
	}
}

public extension UNNotification {
	func message() -> PushMessage {
		return PushMessage(push: self.request.content.userInfo)
	}
}

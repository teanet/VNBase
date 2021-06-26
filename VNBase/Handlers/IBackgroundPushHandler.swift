import UIKit

public protocol IBackgroundPushHandler {
	func handle(message: PushMessage, completion: @escaping (UIBackgroundFetchResult) -> Void)
}

@objc public protocol INotificationResponseHandler {
	func handle(response: UNNotificationResponse, completion: @escaping () -> Void)
	@objc optional func willPresentNotification(_ notification: UNNotification)
}

public protocol IPushHandlersProvider: AnyObject {
	func backgroundPushHandlers() -> [IBackgroundPushHandler]
	func notificationResponseHandlers() -> [INotificationResponseHandler]
}

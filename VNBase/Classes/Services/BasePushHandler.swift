public protocol IBackgroundPushHandler {
	func handle(message: PushMessage, completion: @escaping (UIBackgroundFetchResult) -> Void)
}

public protocol INotificationResponseHandler {
	func handle(response: UNNotificationResponse, completion: @escaping () -> Void)
}

public protocol IPushHandlersProvider: AnyObject {
	func backgroundPushHandlers() -> [IBackgroundPushHandler]
	func notificationResponseHandlers() -> [INotificationResponseHandler]
}

open class BasePushHandler: NSObject {

	public let userNC = UNUserNotificationCenter.current()
	public private(set) var isRespondedToNotificationsRequestAlert: Bool = false
	public private(set) var lastResponse: UNNotificationResponse?
	public private(set) var tokenData: Data?
	public weak var provider: IPushHandlersProvider?

	public init(provider: IPushHandlersProvider?) {
		self.provider = provider
		super.init()
		self.userNC.delegate = self
		self.userNC.getNotificationSettings { (settings) in
			self.isRespondedToNotificationsRequestAlert =
				settings.soundSetting == .enabled ||
				settings.badgeSetting == .enabled ||
				settings.alertSetting == .enabled
		}
	}

	open func shouldShowMessage(for notification: UNNotification) -> UNNotificationPresentationOptions {
		return [.alert]
	}

	public func registerForRemote() {
		UIApplication.shared.registerForRemoteNotifications()
	}

	open func didRegisterForRemoteNotifications(with token: Data) {
		self.tokenData = token
	}

	public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

		let handlers = self.provider?.backgroundPushHandlers() ?? []
		guard !handlers.isEmpty else {
			completionHandler(.noData)
			return
		}

		let message = PushMessage(push: userInfo)
		let group = DispatchGroup()
		var finalResult: UIBackgroundFetchResult = .noData
		for handler in handlers {
			group.enter()
			handler.handle(message: message) { (result) in
				if result == .failed {
					finalResult = .failed
				} else if result == .newData && finalResult != .failed {
					finalResult = .newData
				}
				group.leave()
			}
		}
		group.notify(queue: .main) {
			completionHandler(finalResult)
		}
	}

}

extension BasePushHandler: UNUserNotificationCenterDelegate {

	public func userNotificationCenter(
		_ center: UNUserNotificationCenter,
		willPresent notification: UNNotification,
		withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
	) {
		let options = self.shouldShowMessage(for: notification)
		completionHandler(options)
	}

	// Тап по пушу в открытом или закрытом приложении
	public func userNotificationCenter(
		_ center: UNUserNotificationCenter,
		didReceive response: UNNotificationResponse,
		withCompletionHandler completionHandler: @escaping () -> Void
	) {
		self.lastResponse = response
		let handlers = self.provider?.notificationResponseHandlers() ?? []
		guard !handlers.isEmpty else {
			completionHandler()
			return
		}

		let group = DispatchGroup()
		for handler in handlers {
			group.enter()
			handler.handle(response: response) {
				group.leave()
			}
		}
		group.notify(queue: .main) {
			completionHandler()
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

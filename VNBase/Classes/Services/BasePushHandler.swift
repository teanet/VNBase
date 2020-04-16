public extension Data {
	func pushToken() -> String {
		let token = self.map({ String(format: "%02.2hhx", $0)}).joined()
		return token
	}
}

open class BasePushHandler: NSObject {

	public let userNC = UNUserNotificationCenter.current()
	public private(set) var isRespondedToNotificationsRequestAlert: Bool = false
	public private(set) var lastResponse: UNNotificationResponse?
	public private(set) var tokenData: Data?

	public override init() {
		super.init()
		self.userNC.delegate = self
		self.userNC.getNotificationSettings { (settings) in
			self.isRespondedToNotificationsRequestAlert =
				settings.soundSetting == .enabled ||
				settings.badgeSetting == .enabled ||
				settings.alertSetting == .enabled
		}
	}

	open func shouldShowMessage(for notification: UNNotification) -> Bool {
		return true
	}

	open func didShowMessage(_ message: PushMessage) {
	}

	open func didSelectMessage(
		_ message: PushMessage,
		response: UNNotificationResponse,
		completionHandler: @escaping () -> Void
	) {
		completionHandler()
	}

	public func registerForRemote() {
		UIApplication.shared.registerForRemoteNotifications()
	}

	open func didRegisterForRemoteNotifications(with token: Data) {
		self.tokenData = token
	}

}

extension BasePushHandler: UNUserNotificationCenterDelegate {

	public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

		if self.shouldShowMessage(for: notification) {
			completionHandler(.alert)
		} else {
			completionHandler([])
		}

		let message = PushMessage(push: notification.request.content.userInfo)
		self.didShowMessage(message)
	}

	// Тап по пушу в открытом или закрытом приложении
	public func userNotificationCenter(
		_ center: UNUserNotificationCenter,
		didReceive response: UNNotificationResponse,
		withCompletionHandler completionHandler: @escaping () -> Void
	) {
		self.lastResponse = response
		let message = PushMessage(push: response.notification.request.content.userInfo)
		self.didSelectMessage(message, response: response, completionHandler: completionHandler)
	}

}

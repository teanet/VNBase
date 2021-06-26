import UIKit

open class BaseUserActivityService: IUserActivityRestoring {

	private weak var provider: IUserActivityRestoringProvider?
	private var services: [IUserActivityRestoring] {
		self.provider?.userActivityRestoringServices() ?? []
	}

	public init(provider: IUserActivityRestoringProvider) {
		self.provider = provider
	}

	public func application(
		_ application: UIApplication,
		continue userActivity: NSUserActivity,
		restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
	) -> Bool {
		var doneAny = false
		for handler in self.services {
			let done = handler.application(
				application,
				continue: userActivity,
				restorationHandler: restorationHandler
			)
			doneAny = doneAny || done
			if done && handler.shouldStopProcessingOnSuccess {
				break
			}
		}
		return doneAny
	}
}

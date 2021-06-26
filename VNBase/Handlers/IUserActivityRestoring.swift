import UIKit

public protocol IUserActivityRestoring: AnyObject {
	func application(
		_ application: UIApplication,
		continue userActivity: NSUserActivity,
		restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
	) -> Bool
	var shouldStopProcessingOnSuccess: Bool { get }
}

public extension IUserActivityRestoring {
	var shouldStopProcessingOnSuccess: Bool { false }
}

public protocol IUserActivityRestoringProvider: AnyObject {
	/// порядок имеет значение, первая активность,
	/// которая вернет shouldStopProcessingOnSuccess == true остановит обработку всей цепочки
	func userActivityRestoringServices() -> [IUserActivityRestoring]
}

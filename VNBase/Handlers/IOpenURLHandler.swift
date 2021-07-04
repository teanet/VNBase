import UIKit

public protocol IOpenURLHandler {

	func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool

	@available(iOS 13.0, *)
	func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>)
}

public extension IOpenURLHandler {
	@available(iOS 13.0, *)
	func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
		for context in URLContexts {
			var options = [UIApplication.OpenURLOptionsKey : Any]()
			if let annotation = context.options.annotation {
				options[.annotation] = annotation
			}
			if #available(iOS 14.5, *), let eventAttribution = context.options.eventAttribution {
				options[.eventAttribution] = eventAttribution
			}
			options[.openInPlace] = context.options.openInPlace
			if let sourceApplication = context.options.sourceApplication {
				options[.sourceApplication] = sourceApplication
			}
			_ = self.application(UIApplication.shared, open: context.url, options: options)
		}
	}
}

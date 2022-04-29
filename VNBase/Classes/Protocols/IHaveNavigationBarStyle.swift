import UIKit
@_exported import VNEssential
@_exported import VNHandlers

@objc protocol IHaveNavigationBarStyle {

	@objc optional var navigationBarStyle: NavigationBarStyle? { get }
	func updateNavigationBarStyleIfNeeded()

}

@objc public class NavigationBarStyle: NSObject {

	public static let daySeparatorImage: UIImage = UIImage.image(from: .black, size: CGSize(width: 1, height: .pixel))
	public static let nightSeparatorImage = UIImage.image(from: .black, size: CGSize(width: 1, height: .pixel))

	@objc public let tintColor: UIColor?
	@objc public let barTintColor: UIColor?
	@objc public let translucent: Bool
	@objc public let titleTextAttributes: [NSAttributedString.Key : Any]
	@objc public let largeTitleTextAttributes: [NSAttributedString.Key : Any]
	@objc public let backgroundImage: UIImage?
	@objc public let shadowImage: UIImage?

	public init(
		tintColor: UIColor? = nil,
		barTintColor: UIColor? = nil,
		translucent: Bool = false,
		titleTextAttributes: [NSAttributedString.Key : Any] = [:],
		largeTitleTextAttributes: [NSAttributedString.Key : Any] = [:],
		backgroundImage: UIImage? = nil,
		shadowImage: UIImage? = nil
	) {

		self.tintColor = tintColor
		self.barTintColor = barTintColor
		self.translucent = translucent
		self.titleTextAttributes = titleTextAttributes
		self.largeTitleTextAttributes = largeTitleTextAttributes
		self.backgroundImage = backgroundImage
		self.shadowImage = shadowImage

		super.init()
	}

}

extension UINavigationBar {

	func apply(_ style: NavigationBarStyle) {
		self.tintColor = style.tintColor
		self.barTintColor = style.barTintColor
		self.isTranslucent = style.translucent
		if #available(iOS 15.0, *) {
			let appearance = UINavigationBarAppearance()
			appearance.configureWithOpaqueBackground()
			appearance.shadowImage = style.shadowImage
			appearance.shadowColor = .clear
			appearance.backgroundImage = style.backgroundImage
			appearance.titleTextAttributes = style.titleTextAttributes
			appearance.largeTitleTextAttributes = style.largeTitleTextAttributes
			self.standardAppearance = appearance
			self.scrollEdgeAppearance = appearance
		} else {
			if #available(iOS 11.0, *) {
				self.largeTitleTextAttributes = style.largeTitleTextAttributes
			}
			self.titleTextAttributes = style.titleTextAttributes
			self.setBackgroundImage(style.backgroundImage, for: .default)
			self.shadowImage = style.shadowImage
		}

	}

}

@objc protocol IHaveNavigationBarStyle {

	@objc optional var navigationBarStyle: NavigationBarStyle? { get }
	func updateNavigationBarStyleIfNeeded()

}

@objc public class NavigationBarStyle: NSObject {

	public static let daySeparatorImage: UIImage = UIImage.dgs_newImage(
		from: .black,
		of: CGSize(
			width: 1.0,
			height: 1.0 / UIScreen.main.scale
		)
	)

	public static let nightSeparatorImage: UIImage = UIImage.dgs_newImage(
		from: .black,
		of: CGSize(
			width: 1.0,
			height: 1.0 / UIScreen.main.scale
		)
	)

	@objc public let tintColor: UIColor?
	@objc public let barTintColor: UIColor?
	@objc public let translucent: Bool
	@objc public let titleTextAttributes: [NSAttributedString.Key : Any]
	@objc public let backgroundImage: UIImage?
	@objc public let shadowImage: UIImage?

	public init(
		tintColor: UIColor? = nil,
		barTintColor: UIColor? = nil,
		translucent: Bool = false,
		titleTextAttributes: [NSAttributedString.Key : Any] = [:],
		backgroundImage: UIImage? = nil,
		shadowImage: UIImage? = nil
	) {
		self.tintColor = tintColor
		self.barTintColor = barTintColor
		self.translucent = translucent
		self.titleTextAttributes = titleTextAttributes
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
			self.standardAppearance = appearance
			self.scrollEdgeAppearance = appearance
		} else {
			self.titleTextAttributes = style.titleTextAttributes
			self.setBackgroundImage(style.backgroundImage, for: .default)
			self.shadowImage = style.shadowImage
		}

	}

}

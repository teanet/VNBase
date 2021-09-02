import UIKit

public extension UIImage {

	static func named(
		_ name: String?,
		renderingMode: UIImage.RenderingMode? = nil,
		bundle: Bundle? = nil
	) -> UIImage? {
		guard
			let name = name,
			!name.isEmpty else { return nil }

		let image: UIImage?
		if #available(iOS 13.0, watchOS 6.0, *) {
			image = UIImage(named: name, in: bundle, with: nil)
		} else {
			#if os(iOS)
			image = UIImage(named: name, in: bundle, compatibleWith: nil)
			#elseif os(watchOS)
			image = UIImage(named: name)
			#else
			image = nil
			#endif
		}

		if let renderingMode = renderingMode {
			return image?.withRenderingMode(renderingMode)
		} else {
			return image
		}
	}

	static func templatedNamed(_ name: String?, bundle: Bundle? = nil) -> UIImage? {
		self.named(name, renderingMode: .alwaysTemplate, bundle: bundle)
	}

}

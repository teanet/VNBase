import UIKit

public extension UIImageView {

	static func named(
		_ name: String?,
		renderingMode: UIImage.RenderingMode? = nil
	) -> UIImageView {
		let image = UIImage.named(name, renderingMode: renderingMode)
		return UIImageView(image: image)
	}

	static func templatedNamed(_ name: String?, tint: UIColor? = nil) -> UIImageView {
		let iv = self.named(name, renderingMode: .alwaysTemplate)
		if let tint = tint {
			iv.tintColor = tint
		}
		return iv
	}

}

public extension UIImage {

	static func named(
		_ name: String?,
		renderingMode: UIImage.RenderingMode? = nil
	) -> UIImage? {
		guard
			let name = name,
			!name.isEmpty,
			let image = UIImage(named: name) else { return nil }

		if let renderingMode = renderingMode {
			return image.withRenderingMode(renderingMode)
		} else {
			return image
		}
	}

	static func templatedNamed(_ name: String?) -> UIImage? {
		return self.named(name, renderingMode: .alwaysTemplate)
	}

}

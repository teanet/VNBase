import UIKit

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
		self.named(name, renderingMode: .alwaysTemplate)
	}

}

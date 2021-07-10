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

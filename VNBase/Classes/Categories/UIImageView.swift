import UIKit

public extension UIImageView {

	static func named(
		_ name: String?,
		renderingMode: UIImage.RenderingMode? = nil,
		bundle: Bundle? = nil
	) -> UIImageView {
		let image = UIImage.named(name, renderingMode: renderingMode, bundle: bundle)
		return UIImageView(image: image)
	}

	static func templatedNamed(
		_ name: String?,
		tint: UIColor? = nil,
		bundle: Bundle? = nil
	) -> UIImageView {
		let iv = self.named(name, renderingMode: .alwaysTemplate, bundle: bundle)
		if let tint = tint {
			iv.tintColor = tint
		}
		return iv
	}

}

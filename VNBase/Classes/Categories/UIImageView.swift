public extension UIImageView {

	static func named(
		_ name: String?,
		renderingMode: UIImage.RenderingMode? = nil
	) -> UIImageView {
		let image: UIImage? = {
			guard
				let name = name,
				!name.isEmpty,
				let image = UIImage(named: name) else { return nil }

			if let renderingMode = renderingMode {
				return image.withRenderingMode(renderingMode)
			} else {
				return image
			}
		}()
		return UIImageView(image: image)
	}

	static func templatedNamed(_ name: String?) -> UIImageView {
		return self.named(name, renderingMode: .alwaysTemplate)
	}

}

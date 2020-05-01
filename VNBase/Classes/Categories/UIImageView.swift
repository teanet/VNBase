public extension UIImageView {

	static func named(
		_ name: String?,
		renderingMode: UIImage.RenderingMode = .automatic
	) -> UIImageView {
		let image: UIImage? = {
			guard let name = name, !name.isEmpty else { return nil }
			return UIImage(named: name)
		}()
		return UIImageView(image: image)
	}

	static func templatedNamed(_ name: String?) -> UIImageView {
		return self.named(name, renderingMode: .alwaysTemplate)
	}

}

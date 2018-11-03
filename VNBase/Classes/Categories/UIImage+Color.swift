public extension UIImage {

	public static func rectImage(colored color: UIColor) -> UIImage? {
		let size = CGSize(width: 20, height: 20)
		UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
		guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
		ctx.saveGState()

		let rect = CGRect(origin: .zero, size: size)
		ctx.setFillColor(color.cgColor)
		ctx.fill(rect)

		ctx.restoreGState()

		// Сливаем всё в итоговую картинку
		let resultImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		return resultImage
	}

	/// Возвращает картинку–кружок с диаметром и цветом
	public static func circle(diameter: CGFloat, color: UIColor) -> UIImage {
		let circleSize = CGSize(width: diameter, height: diameter)
		UIGraphicsBeginImageContextWithOptions(circleSize, false, 0)
		let ctx = UIGraphicsGetCurrentContext()!
		ctx.saveGState()

		let rect = CGRect(origin: .zero, size: circleSize)
		ctx.setFillColor(color.cgColor)
		ctx.fillEllipse(in: rect)

		ctx.restoreGState()
		let circleImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return circleImage!
	}

	/// Рисует поверх картинки переданную в параметр картинку
	public func withOverdraw(image: UIImage?) -> UIImage {
		guard let image = image else { return self }

		UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
		let centerOrigin = CGPoint(
			x: (self.size.width - image.size.width) / 2.0,
			y: (self.size.height - image.size.height) / 2.0)

		self.draw(at: .zero)
		image.draw(at: centerOrigin)
		let resultImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		return resultImage
	}

	/// Возвращает картинку, покрашенную в цвет color
	@objc public func colorized(with color: UIColor?) -> UIImage {
		guard let color = color else { return self }

		UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)

		let context = UIGraphicsGetCurrentContext()!
		context.translateBy(x: 0.0, y: self.size.height)
		context.scaleBy(x: 1.0, y: -1.0)
		context.setBlendMode(.normal)

		let rect = CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height)
		context.clip(to: rect, mask: self.cgImage!)

		color.setFill()
		context.fill(rect)

		let colorizedImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		return colorizedImage
	}
	
}

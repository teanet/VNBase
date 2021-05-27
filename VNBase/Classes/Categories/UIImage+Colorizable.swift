import UIKit

public extension UIImage {

	/// Возвращает картинку нарисованную на прямоугольнике цвета color с заданным размером
	/// Можно использовать прозрачный цвет или nil чтобы изменить размер картинки
	func onRect(colored color: UIColor? = nil, size: CGSize, filled: Bool = true) -> UIImage {

		UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
		guard let ctx = UIGraphicsGetCurrentContext() else { return self }
		ctx.saveGState()

		// делаем заливку или обводку
		if let color = color, color != .clear {

			let rect = CGRect(origin: .zero, size: size)
			if filled {
				ctx.setFillColor(color.cgColor)
				ctx.fill(rect)
			} else {
				ctx.setStrokeColor(color.cgColor)
				ctx.setLineWidth(1)
				ctx.stroke(rect)
			}
		}

		// Переворачиваем контекст в нужную систему координат (флипаем иконку по y)
		ctx.translateBy(x: 0.0, y: size.height)
		ctx.scaleBy(x: 1.0, y: -1.0)

		let x = ((size.width - self.size.width) * 0.5).rounded(.down)
		let y = ((size.height - self.size.height) * 0.5).rounded(.down)
		ctx.draw(self.cgImage!, in: CGRect(origin: CGPoint(x: x, y: y), size: self.size))

		ctx.restoreGState()

		// Сливаем всё в итоговую картинку
		let resultImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		return resultImage
	}

	/// Меняет размер картинки
	func resize(to size: CGSize) -> UIImage {

		UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
		guard let ctx = UIGraphicsGetCurrentContext() else { return self }
		ctx.saveGState()

		// Переворачиваем контекст в нужную систему координат (флипаем иконку по y)
		ctx.translateBy(x: 0.0, y: size.height)
		ctx.scaleBy(x: 1.0, y: -1.0)

		ctx.draw(self.cgImage!, in: CGRect(origin: CGPoint(x: 0, y: 0), size: size))

		ctx.restoreGState()

		// Сливаем всё в итоговую картинку
		let resultImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		return resultImage
	}

	/// Возвращает картинку нарисованную на кружке цвета color, диаметром
	func onCircle(colored color: UIColor?, diameter: CGFloat, filled: Bool = true) -> UIImage {
		guard let color = color else { return self }

		let substrateSize = CGSize(width: diameter, height: diameter)

		// Рисуем кружок нужного цвета
		UIGraphicsBeginImageContextWithOptions(substrateSize, false, UIScreen.main.scale)
		let ctx = UIGraphicsGetCurrentContext()!

		ctx.saveGState()
		let rect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: substrateSize)
		let fillColor = filled ? color.cgColor : UIColor.white.cgColor
		ctx.setFillColor(fillColor)
		ctx.fillEllipse(in: rect)

		// Если кружок не закрашенный, просто обводим его линией нужного цвета с поправкой на толщину линии
		if !filled {
			let strokeWidth: CGFloat = 1.0
			let strokeRect = CGRect(
				x: rect.origin.x + strokeWidth / 2.0,
				y: rect.origin.y + strokeWidth / 2.0,
				width: rect.width - strokeWidth,
				height: rect.height - strokeWidth
			)
			ctx.setStrokeColor(color.cgColor)
			ctx.setLineWidth(1.0)
			ctx.strokeEllipse(in: strokeRect)
		}

		// Поверх кружка рисуем иконку по центру кружка
		let overlayOrigin = CGPoint(
			x: substrateSize.width / 2.0 - self.size.width / 2.0,
			y: substrateSize.height / 2.0 - self.size.height / 2.0
		)
		let overlayRect = CGRect.init(origin: overlayOrigin, size: self.size)

		// Переворачиваем контекст в нужную систему координат (флипаем иконку по y)
		ctx.translateBy(x: 0.0, y: substrateSize.height)
		ctx.scaleBy(x: 1.0, y: -1.0)

		ctx.draw(self.cgImage!, in: overlayRect)

		// И обратно ради хорощего тона
		ctx.translateBy(x: 0.0, y: -overlayRect.size.height)
		ctx.scaleBy(x: 1.0, y: -1.0)

		ctx.restoreGState()

		// Сливаем всё в итоговую картинку
		let resultImage = UIGraphicsGetImageFromCurrentImageContext()!

		UIGraphicsEndImageContext()

		return resultImage
	}

	/// Возвращает картинку–кружок с диаметром и цветом
	@objc static func circle(diameter: CGFloat, color: UIColor) -> UIImage {
		let circleSize = CGSize(width: diameter, height: diameter)
		UIGraphicsBeginImageContextWithOptions(circleSize, false, 0)
		let ctx = UIGraphicsGetCurrentContext()!
		ctx.saveGState()

		let rect = CGRect.init(origin: .zero, size: circleSize)
		ctx.setFillColor(color.cgColor)
		ctx.fillEllipse(in: rect)

		ctx.restoreGState()
		let circleImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return circleImage!
	}

	/// Возвращает картинку, покрашенную в цвет color
	@objc func colorized(with color: UIColor?) -> UIImage {
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

	/// Возвращает левую половинку от картинки
	func leftHalf() -> UIImage? {
		guard let cgImage = self.cgImage else { return nil }

		let newSize = CGSize(
			width: self.size.width * self.scale / 2.0,
			height: self.size.height * self.scale
		)
		let newBounds = CGRect(origin: .zero, size: newSize)

		guard let croppedCGImage = cgImage.cropping(to: newBounds) else { return nil }
		return UIImage(
			cgImage: croppedCGImage,
			scale: self.scale,
			orientation: .up
		)
	}

	/// Рисует поверх картинки переданную в параметр картинку
	func withOverdraw(
		image: UIImage?,
		offset: CGPoint = .zero
	) -> UIImage {
		guard let image = image else { return self }

		UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
		self.draw(at: .zero)
		image.draw(at: offset)
		let resultImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		return resultImage
	}

	static func rectImage(
		colored color: UIColor,
		size: CGSize = CGSize(width: 20, height: 20)
	) -> UIImage? {
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

	static func image(from color: UIColor, size: CGSize) -> UIImage {
		UIGraphicsImageRenderer(size: size).image { ctx in
			color.setFill()
			ctx.fill(CGRect(origin: .zero, size: size))
		}
	}

	static func stretchableImage(from color: UIColor) -> UIImage {
		self.image(from: color, size: CGSize(width: 1, height: 1))
			.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0)
	}

}

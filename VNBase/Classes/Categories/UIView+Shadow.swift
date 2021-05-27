import UIKit

public extension UIView {

	func addShadow(
		color: UIColor? = nil,
		offset: CGSize = CGSize(width: 0.0, height: -3.0),
		radius: CGFloat = 3.0,
		opacity: Float = 1.0
	) {
		self.layer.masksToBounds = false
		self.layer.shadowColor = color?.cgColor
		self.layer.shadowOffset = offset
		self.layer.shadowRadius = radius
		self.layer.shadowOpacity = opacity
	}

	func addCircleShadow(
		offset: CGSize = CGSize(width: 0, height: 1),
		radius: CGFloat = 1.0,
		opacity: Float = 0.25,
		roundedRect: CGRect,
		cornerRadius: CGFloat
	) {
		let layer: CALayer = self.layer
		layer.shadowOffset = offset
		layer.shadowRadius = radius
		layer.shadowOpacity = opacity
		let bezierPath = UIBezierPath(
			roundedRect: roundedRect,
			cornerRadius: cornerRadius
		)
		layer.shadowPath = bezierPath.cgPath
	}

}

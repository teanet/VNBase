public extension UIView {

	class var pixelSeparator: UIView {
		let separator = UIView()
		separator.backgroundColor = .separatorGray
		separator.heightAnchor.constraint(equalToConstant: CGFloat.pixel).isActive = true

		return separator
	}

	class var pointSeparator: UIView {
		let separator = UIView()
		separator.backgroundColor = .separatorGray
		separator.heightAnchor.constraint(equalToConstant: 1).isActive = true

		return separator
	}

	class var blur: UIView {
		let v = UIView()
		if let filter = CIFilter(name:"CIGaussianBlur", parameters: [kCIInputRadiusKey: 7]) {
			v.layer.backgroundColor = UIColor.promoBlue.cgColor
			v.layer.opacity = 0.8
			v.layer.backgroundFilters = [filter]
		}
		return v
	}

	public func addShadow(
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
    
    public func addCircleShadow(
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

//	public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
//		let maskPath = UIBezierPath(roundedRect: self.bounds,
//									byRoundingCorners: corners,
//									cornerRadii: CGSize(width: radius, height: radius))
//		let maskLayer = CAShapeLayer()
//		maskLayer.frame = self.bounds
//		maskLayer.path = maskPath.cgPath
//		self.layer.mask = maskLayer
//		self.layer.masksToBounds = true
//	}

}

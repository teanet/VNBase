open class GradientView: UIView {

	public typealias ColorWithLocaction = (color: UIColor, location: CGFloat)
	public struct Points {
		let start: CGPoint
		let end: CGPoint

		public static let vertical = Points(start: CGPoint(x: 0.5, y: 0), end: CGPoint(x: 0.5, y: 1))
		public static let horisontal = Points(start: CGPoint(x: 0, y: 0.5), end: CGPoint(x: 1, y: 0.5))

		public init(start: CGPoint, end: CGPoint) {
			self.start = start
			self.end = end
		}

	}

	public var points: Points {
		didSet {
			self.gradientLayer.startPoint = self.points.start
			self.gradientLayer.endPoint = self.points.end
		}
	}
	public var gradientType: CAGradientLayerType {
		didSet {
			self.gradientLayer.type = self.gradientType
		}
	}

	private(set) var colors: [UIColor]
	private var locations: [NSNumber]
	private var gradientLayer: CAGradientLayer {
		// swiftlint:disable:next force_cast
		return self.layer as! CAGradientLayer
	}

	final public override class var layerClass: AnyClass { CAGradientLayer.self }

	public init(
		frame: CGRect = .zero,
		colorsWithLocactions: [ColorWithLocaction] = [],
		points: Points = .horisontal,
		gradientType: CAGradientLayerType = .axial
	) {
		self.points = points
		self.colors = colorsWithLocactions.map({ $0.color })
		self.locations = colorsWithLocactions.map({ NSNumber(value: Double($0.location)) })
		self.gradientType = gradientType
		super.init(frame: frame)
		self.layer.needsDisplayOnBoundsChange = true
		self.reload()
	}

	@available(*, unavailable)
	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public func updateColorsWithLocations(_ colors: [ColorWithLocaction]) {
		self.colors = colors.map({ $0.color })
		self.locations = colors.map({ NSNumber(value: Double($0.location)) })
		self.reload()
	}

	public func updateColors(colors: [UIColor]) {
		self.updateColorsWithLocations(colors.colorsWithLocactions())
	}

	private func reload() {
		let gradientLayer = self.gradientLayer
		gradientLayer.type = self.gradientType
		gradientLayer.colors = self.colors.map({ $0.cgColor })
		gradientLayer.locations = self.locations
		gradientLayer.startPoint = self.points.start
		gradientLayer.endPoint = self.points.end
	}

}

public extension Array where Element == UIColor {

	func colorsWithLocactions() -> [GradientView.ColorWithLocaction] {
		guard !self.isEmpty else { return [] }
		guard self.count > 1 else {
			return [(self[0], 0)]
		}
		let count = CGFloat(self.count)
		return self.enumerated().map {
			GradientView.ColorWithLocaction(
				color: $0.element,
				location: CGFloat($0.offset) / (count - 1)
			)
		}
	}

}

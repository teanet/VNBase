import UIKit

open class GradientView: UIView {

	public typealias ColorWithLocation = (color: UIColor, location: CGFloat)
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
		colorsWithLocations: [ColorWithLocation] = [],
		points: Points = .horisontal,
		gradientType: CAGradientLayerType = .axial
	) {
		self.points = points
		self.colors = colorsWithLocations.map({ $0.color })
		self.locations = colorsWithLocations.map({ NSNumber(value: Double($0.location)) })
		self.gradientType = gradientType
		super.init(frame: frame)
		self.layer.needsDisplayOnBoundsChange = true
		self.reload()
	}

	public convenience init(
		frame: CGRect = .zero,
		colors: [UIColor] = [],
		points: Points = .horisontal,
		gradientType: CAGradientLayerType = .axial
	) {
		self.init(
			frame: frame,
			colorsWithLocations: colors.colorsWithLocations(),
			points: points,
			gradientType: gradientType
		)
	}

	@available(*, unavailable)
	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		self.reload()
	}

	public func updateColorsWithLocations(_ colors: [ColorWithLocation]) {
		self.colors = colors.map({ $0.color })
		self.locations = colors.map({ NSNumber(value: Double($0.location)) })
		self.reload()
	}

	public func updateColors(colors: [UIColor]) {
		self.updateColorsWithLocations(colors.colorsWithLocations())
	}

	private func reload() {
		let gradientLayer = self.gradientLayer
		gradientLayer.type = self.gradientType
		gradientLayer.colors = self.colors.map({ $0.cgColor(with: self.traitCollection) })
		gradientLayer.locations = self.locations
		gradientLayer.startPoint = self.points.start
		gradientLayer.endPoint = self.points.end
	}

}

public extension Array where Element == UIColor {

	func colorsWithLocations() -> [GradientView.ColorWithLocation] {
		guard !self.isEmpty else { return [] }
		guard self.count > 1 else {
			return [(self[0], 0)]
		}
		let count = CGFloat(self.count)
		return self.enumerated().map {
			GradientView.ColorWithLocation(
				color: $0.element,
				location: CGFloat($0.offset) / (count - 1)
			)
		}
	}

}

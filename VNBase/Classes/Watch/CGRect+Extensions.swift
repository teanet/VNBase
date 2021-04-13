import CoreGraphics.CGGeometry

public extension CGRect {

	var maxSize: CGFloat {
		max(self.size.height, self.size.width)
	}
	var boundsCenter: CGPoint {
		CGPoint(x: self.width * 0.5, y: self.height * 0.5)
	}
	var center: CGPoint {
		CGPoint(x: self.midX, y: self.midY)
	}
}

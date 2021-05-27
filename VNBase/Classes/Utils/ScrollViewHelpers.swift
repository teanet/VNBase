import UIKit

extension CAMediaTimingFunction {

	func value(at progress: Float) -> Float {
		var a: [Float] = [0.0,0.0]
		var b: [Float] = [0.0,0.0]
		var c: [Float] = [0.0,0.0]
		var d: [Float] = [0.0,0.0]
		self.getControlPoint(at: 0, values: &a)
		self.getControlPoint(at: 1, values: &b)
		self.getControlPoint(at: 2, values: &c)
		self.getControlPoint(at: 3, values: &d)

		let x = progress
		let t = rootOfCubic(a: -a[0]+3*b[0]-3*c[0]+d[0], b: 3*a[0]-6*b[0]+3*c[0], c: -3*a[0]+3*b[0], d: a[0]-x, startPoint: x)
		let y = cubicFunctionValue(a: -a[1]+3*b[1]-3*c[1]+d[1], b: 3*a[1]-6*b[1]+3*c[1], c: -3*a[1]+3*b[1], d: a[1], x: t)
		return y
	}

}

func cubicFunctionValue(a: Float, b: Float, c: Float, d: Float, x: Float) -> Float {
	return a*x*x*x + b*x*x + c*x + d
}

func cubicDerivativeValue(a: Float, b: Float, c: Float, d: Float, x: Float) -> Float {
	return (3*a*x*x) + (2*b*x) + c
}

func rootOfCubic(a: Float, b: Float, c: Float, d: Float, startPoint: Float) -> Float {
	var x = startPoint
	var y: Int = 0
	var lastX: Float = 1
	let kMaximumSteps: Int = 10
	let kApproximationTolerance: Float = 0.0000001
	while y <= kMaximumSteps && abs(lastX - x) > kApproximationTolerance {
		lastX = x
		x -= cubicFunctionValue(a: a, b: b, c: c, d: d, x: x) / cubicDerivativeValue(a: a, b: b, c: c, d: d, x: x)
		y += 1
	}
	return x
}

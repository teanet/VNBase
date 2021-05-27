import UIKit

public extension UIStackView {

	func addArrangedSubviews(_ views: [UIView]) {
		for view in views {
			self.addArrangedSubview(view)
		}
	}

	func removeAllArrangedSubviews() {
		let subviews = self.arrangedSubviews
		subviews.forEach {
			self.removeArrangedSubview($0)
			$0.removeFromSuperview()
		}
	}

	static func stack(
		views: [UIView] = [],
		axis: NSLayoutConstraint.Axis = .vertical,
		distribution: UIStackView.Distribution = .equalSpacing,
		spacing: CGFloat = 0,
		alignment: UIStackView.Alignment = .fill
	) -> Self {
		let stack = self.init()
		stack.axis = axis
		stack.distribution = distribution
		stack.spacing = spacing
		stack.addArrangedSubviews(views)
		stack.alignment = alignment
		return stack
	}

}

import UIKit

open class MultilineLabel: UILabel {

	override open var bounds: CGRect {
		didSet {
			guard self.numberOfLines == 0 else { return }

			if self.preferredMaxLayoutWidth != self.bounds.width {
				self.preferredMaxLayoutWidth = self.bounds.width
				self.setNeedsUpdateConstraints()
			}
		}
	}

	override open var intrinsicContentSize: CGSize {
		var size = super.intrinsicContentSize
		if self.numberOfLines == 0 {
			size.height += 1
		}
		return size
	}

	public init() {
		super.init(frame: .zero)
		self.numberOfLines = 0
	}

	@available(*, unavailable)
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

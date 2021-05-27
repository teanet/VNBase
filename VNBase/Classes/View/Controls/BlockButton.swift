import UIKit

public typealias ButtonBlock = ((UIButton) -> Swift.Void)

open class BlockButton: UIButton {
	open override var intrinsicContentSize: CGSize {
		if self.height == UIView.noIntrinsicMetric {
			return super.intrinsicContentSize
		} else {
			return .height(self.height)
		}
	}
	public var onTap: ButtonBlock?
	public var fadeOnHighlighted: Bool
	open override var isHighlighted: Bool {
		didSet {
			if self.fadeOnHighlighted {
				self.alpha = self.isHighlighted.highlightedAlpha
			}
		}
	}
	public var height: CGFloat {
		didSet {
			self.invalidateIntrinsicContentSize()
		}
	}

	public init(
		block: ButtonBlock? = nil,
		fadeOnHighlighted: Bool = false,
		height: CGFloat = UIView.noIntrinsicMetric
	) {
		self.onTap = block
		self.fadeOnHighlighted = fadeOnHighlighted
		self.height = height
		super.init(frame: .zero)
		self.addTarget(self, action: #selector(self.onTap(_:)), for: .touchUpInside)
	}

	@available(*, unavailable)
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	@objc private func onTap(_ sw: UIButton) {
		self.onTap?(self)
	}

}

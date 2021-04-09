public typealias ButtonBlock = ((UIButton) -> Swift.Void)

open class BlockButton: UIButton {
	public var onTap: ButtonBlock?
	public var fadeOnHighlighted: Bool
	open override var isHighlighted: Bool {
		didSet {
			if self.fadeOnHighlighted {
				self.alpha = self.isHighlighted.highlightedAlpha
			}
		}
	}
	public init(
		block: ButtonBlock? = nil,
		fadeOnHighlighted: Bool = false
	) {
		self.onTap = block
		self.fadeOnHighlighted = fadeOnHighlighted
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

public typealias ButtonBlock = ((UIButton) -> Swift.Void)

open class BlockButton: UIButton {
	public var onTap: ButtonBlock?
	public init(block: ButtonBlock? = nil) {
		self.onTap = block
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

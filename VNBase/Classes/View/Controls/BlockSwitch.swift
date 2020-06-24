open class BlockSwitch: UISwitch {
	public var onSwitch: BoolBlock?
	public init(block: BoolBlock? = nil) {
		self.onSwitch = block
		super.init(frame: .zero)
		self.addTarget(self, action: #selector(self.onSwitch(_:)), for: .valueChanged)
	}

	@available(*, unavailable)
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	@objc private func onSwitch(_ sw: UISwitch) {
		self.onSwitch?(self.isOn)
	}

}

@available(iOS 14.0, *)
open class SwitchCell: BaseCell<SwitchCellVM> {
	private let sw = UISwitch()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.accessoryView = self.sw
		self.sw.addTarget(self, action: #selector(self.switchh), for: .valueChanged)
		var cell = UIListContentConfiguration.cell()
		cell.text = "Live location"
		self.contentConfiguration = cell
	}

	@objc private func switchh() {
		self.viewModel?.toggle()
	}

	open override func viewModelChanged() {
		super.viewModelChanged()
		guard let vm = self.viewModel else { return }

		self.sw.setOn(vm.isOn, animated: false)
		var cell = UIListContentConfiguration.cell()
		cell.text = vm.title
		self.contentConfiguration = cell
	}

	open override class func height(with viewModel: SwitchCellVM, width: CGFloat) -> CGFloat {
		return 50
	}
}

@available(iOS 14.0, *)
open class SwitchCellVM: BaseCellVM {
	open func cellClass() -> UITableViewCell.Type { SwitchCell.self }

	open var isOn: Bool { assertionFailure("Override me"); return false }
	fileprivate let title: String

	public init(title: String) {
		self.title = title
	}

	open func toggle() {
		assertionFailure("Override me")
	}
}

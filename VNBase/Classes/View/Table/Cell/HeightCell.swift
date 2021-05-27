import UIKit

public final class HeightCell: BaseCell<HeightCellVM> {

	private let separator = UIView()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.selectionStyle = .none
		self.contentView.addSubview(self.separator)
	}

	public override func viewModelChanged() {
		super.viewModelChanged()
		guard let vm = self.viewModel else { return }
		self.separator.backgroundColor = vm.separatorColor
		self.separator.isHidden = vm.separatorInset == .dgs_invisibleSeparator
		self.makeClearBackground(color: vm.backgroundColor)
		self.setNeedsLayout()
	}

	public override func layoutSubviews() {
		super.layoutSubviews()
		guard let vm = self.viewModel else { return }

		var frame = self.bounds.inset(by: vm.separatorInset)
		frame.size.height = vm.separatorHeight
		self.separator.frame = frame
	}

	public override class func height(with viewModel: HeightCellVM, width: CGFloat) -> CGFloat {
		return viewModel.height
	}

}

public final class HeightCellVM: BaseCellVM {

	func cellClass() -> UITableViewCell.Type { HeightCell.self }

	let height: CGFloat
	let separatorColor: UIColor
	let separatorInset: UIEdgeInsets
	let separatorHeight: CGFloat
	let backgroundColor: UIColor

	public init(
		height: CGFloat,
		separatorColor: UIColor = .clear,
		separatorInset: UIEdgeInsets = .dgs_invisibleSeparator,
		separatorHeight: CGFloat = .pixel,
		backgroundColor: UIColor = .clear
	) {
		self.separatorColor = separatorColor
		self.separatorInset = separatorInset
		self.separatorHeight = separatorHeight
		self.height = height
		self.backgroundColor = backgroundColor
	}

}

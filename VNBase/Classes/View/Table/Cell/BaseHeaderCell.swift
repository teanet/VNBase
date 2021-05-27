import SnapKit
import UIKit
import VNEssential

open class BaseHeaderCell<TVM: BaseHeaderCellVM>: BaseCell<TVM> {

	public let header = MultilineLabel()
	private var constraint = [Constraint]()

	public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		let insets = UIEdgeInsets.zero
		self.contentView.addSubview(self.header) {
			self.constraint ++= $0.top.leading.trailing.equalToSuperview().inset(insets).constraint
			self.constraint ++= $0.bottom.equalToSuperview().inset(insets).priority(.high).constraint
		}

		self.makeClearBackground()
		self.selectionStyle = .none
	}

	open override func viewModelChanged() {
		super.viewModelChanged()

		guard let vm = self.viewModel else { return }

		self.header.apply(vm.style, text: vm.title)
		if let insets = vm.insets {
			self.constraint.forEach {
				$0.update(inset: insets)
			}
		}
	}

	open override class func height(with viewModel: TVM, width: CGFloat) -> CGFloat {
		if let height = viewModel.height {
			return height
		} else {
			return super.height(with: viewModel, width: width)
		}
	}

}

open class BaseHeaderCellVM: BaseCellVM {

	open func cellClass() -> UITableViewCell.Type { BaseHeaderCell.self }

	var title: String
	let style: TextStyle
	let insets: UIEdgeInsets?
	let height: CGFloat?

	public init(
		title: String,
		style: TextStyle,
		insets: UIEdgeInsets? = nil,
		height: CGFloat? = nil
	) {
		self.title = title
		self.style = style
		self.insets = insets
		self.height = height
		super.init()
	}

}

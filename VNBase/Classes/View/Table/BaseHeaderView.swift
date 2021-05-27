import UIKit

open class BaseHeaderViewVM: BaseCellVM {
}

open class BaseHeaderView<TViewModel: BaseHeaderViewVM>: UITableViewHeaderFooterView,
	Registerable,
	IHaveHeight,
	ViewModelChangedDelegate,
	IHaveViewModel {

	@available(*, unavailable)
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
	}

	public var viewModelObject: BaseVM? {
		didSet {
			if oldValue?.didChangeDelegate === self {
				oldValue?.didChangeDelegate = nil
			}
			self.viewModelObject?.didChangeDelegate = self

			self.viewModelChanged()
		}
	}

	private var constraintsCreated = false

	public static func internalHeight(with viewModel: BaseCellVM, width: CGFloat) -> CGFloat {
		guard let vm = viewModel as? TViewModel else { return UITableView.automaticDimension }
		return self.height(with: vm, width: width)
	}
	public static func internalEstimatedHeight(with viewModel: BaseCellVM) -> CGFloat {
		return 44
	}
	open class func height(with viewModel: TViewModel, width: CGFloat) -> CGFloat {
		return UITableView.automaticDimension
	}

	public static func identifier() -> String {
		return TViewModel.reuseIdentifier
	}

	open class func nib() -> UINib? {
		return nil
	}

	open override func prepareForReuse() {
		super.prepareForReuse()
		self.viewModel = nil
	}

	open var viewModel: TViewModel? {
		get {
			return self.viewModelObject as? TViewModel
		}
		set {
			self.viewModelObject = newValue
		}
	}

	open func viewModelChanged() {
	}

	open override func updateConstraints() {

		if !self.constraintsCreated {
			self.createConstraints()
			self.constraintsCreated = true
		}

		super.updateConstraints()
	}

	open func createConstraints() {
	}

}

import Foundation

open class BaseView<TViewModel: BaseVM> : UIView, IHaveViewModel, ViewModelChangedDelegate {

	var viewModelObject: BaseVM? {
		didSet {
			if oldValue?.didChangeDelegate === self {
				oldValue?.didChangeDelegate = nil
			}
			self.viewModelObject?.didChangeDelegate = self

			self.viewModelChanged()
		}
	}

	private var constraintsCreated = false

	open var viewModel: TViewModel? {
		get {
			return self.viewModelObject as? TViewModel
		}
		set {
			self.viewModelObject = newValue
		}
	}

	open override func updateConstraints() {

		if !self.constraintsCreated {
			self.createConstraints()
			self.constraintsCreated = true
		}

		super.updateConstraints()
	}

	open func viewModelChanged() {
	}

	public init() {
		super.init(frame: .zero)
	}

	@available(*, unavailable)
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	open func createConstraints() {

	}
}

import UIKit

open class BaseView<TViewModel: BaseVM> : UIView, IHaveViewModel, ViewModelChangedDelegate {

	public var shouldPassOverTouches = false

	open var viewModelObject: BaseVM? {
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

	open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		let resultView = super.hitTest(point, with: event)
		if self.shouldPassOverTouches {
			if resultView === self {
				return nil
			}
		}
		return resultView
	}

	open override func updateConstraints() {

		if !self.constraintsCreated {
			self.createConstraints()
			self.constraintsCreated = true
		}

		super.updateConstraints()
	}

	open func viewModelChanged() {
		guard let vm = self.viewModel else { return }
		switch vm.viewState {
			case .other:
				break
			case .hidden(let isHidden):
				self.isHidden = isHidden
			case .transparent(alpha: let alpha):
				self.alpha = alpha
		}
	}

	public init() {
		super.init(frame: .zero)
		self.updateColors()
	}

	@available(*, unavailable)
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		self.updateColors()
	}

	open func createConstraints() {}
	open func updateColors() {}

}

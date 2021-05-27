import UIKit

open class BaseControl<TViewModel: BaseVM>: UIControl, IHaveViewModel, ViewModelChangedDelegate {

	public var viewModelObject: BaseVM? {
		didSet {
			if oldValue?.didChangeDelegate === self {
				oldValue?.didChangeDelegate = nil
			}
			self.viewModelObject?.didChangeDelegate = self

			self.viewModelChanged()
		}
	}

	public override init(frame: CGRect = .zero) {
		super.init(frame: frame)
		self.addTarget(self, action: #selector(self.handleSelection), for: .touchUpInside)
	}

	@available(*, unavailable)
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	open var viewModel: TViewModel? {
		get {
			return self.viewModelObject as? TViewModel
		}
		set {
			self.viewModelObject = newValue
		}
	}

	open func viewModelChanged() {}

	@objc open func handleSelection() {}

}

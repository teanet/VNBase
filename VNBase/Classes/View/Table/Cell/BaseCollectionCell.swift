import UIKit

public protocol IHaveSize: AnyObject {
	static func internalSize(with viewModel: BaseCellVM, size: CGSize) -> CGSize
}

public extension UICollectionView {

	func register(_ classes: RegisterableClass...) {
		self.registerClasses(classes)
	}

	func registerClasses(_ classes: [RegisterableClass]) {
		for regClass in classes {
			guard let cellClass = regClass as? UICollectionViewCell.Type else {
				assertionFailure("Can't register cell class \(String(describing: regClass))")
				continue
			}

			let identifier = regClass.identifier()
			if let nib = regClass.nib() {
				self.register(nib, forCellWithReuseIdentifier: identifier)
			} else {
				self.register(cellClass, forCellWithReuseIdentifier: identifier)
			}
		}
	}

}

// Базовая ячейка для создания ее из ксиба
open class BaseCollectionViewXibCell<TViewModel : BaseCellVM> : CollectionViewCell<TViewModel> {

	open override class func nib() -> UINib? {
		let bundle = Bundle.main
		let name = "\(self)"
		let nib = UINib(
			nibName: name,
			bundle: bundle
		)

		return nib
	}

	@available(*, unavailable)
	public override init(frame: CGRect) {
		fatalError("use init?(coder: NSCoder)")
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

}

// Базовая ячейка для создания ее с ручным лейаутом
open class BaseCollectionViewCell<TViewModel : BaseCellVM> : CollectionViewCell<TViewModel> {

	public override init(frame: CGRect) {
		super.init(frame: frame)
	}

	@available(*, unavailable)
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

}

// САМАЯ базовая ячейка, которая может быть создана как из ксиба, так и с ручным лейаутом
open class CollectionViewCell<TViewModel : BaseCellVM> : UICollectionViewCell,
	IHaveViewModel,
	ViewModelChangedDelegate,
	Registerable,
	IHaveSize {

	private var constraintsCreated = false

	public static func internalSize(with viewModel: BaseCellVM, size: CGSize) -> CGSize {
		guard let vm = viewModel as? TViewModel else {
			return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
		}
		return self.size(with: vm, size: size)
	}

	open class func size(with viewModel: TViewModel, size: CGSize) -> CGSize {
		return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
	}

	open class func nib() -> UINib? {
		return nil
	}

	public static func identifier() -> String {
		return TViewModel.reuseIdentifier
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

	public var viewModel: TViewModel? {
		get {
			return self.viewModelObject as? TViewModel
		}
		set {
			self.viewModelObject = newValue
		}
	}

	open func viewModelChanged() {}

	// MARK: override

	open override func prepareForReuse() {
		super.prepareForReuse()

		self.viewModel = nil
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

import UIKit

public extension UICollectionView {

	func register(headerClasses classes: RegisterableClass...) {
		self.register(headerClasses: classes)
	}

	func register(headerClasses classes: [RegisterableClass]) {
		self.register(viewClasses: classes, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
	}

	func register(footerClasses classes: RegisterableClass...) {
		self.register(footerClasses: classes)
	}

	func register(footerClasses classes: [RegisterableClass]) {
		self.register(viewClasses: classes, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
	}

	private func register(viewClasses classes: [RegisterableClass], forSupplementaryViewOfKind viewKind: String) {
		for regClass in classes {
			guard let viewClass = regClass as? UICollectionReusableView.Type else {
				assertionFailure("Can't register class \(String(describing: regClass)) for collection supplementary view")
				continue
			}
			self.register(viewClass, forSupplementaryViewOfKind: viewKind, withReuseIdentifier: regClass.identifier())
		}
	}
}

open class BaseCollectionReusableView<TViewModel: BaseCellVM>: UICollectionReusableView,
	IHaveViewModel,
	Registerable,
	ViewModelChangedDelegate {

	public static func nib() -> UINib? {
		return nil
	}

	public static func identifier() -> String {
		return TViewModel.reuseIdentifier
	}

	public override init(frame: CGRect) {
		super.init(frame: frame)
	}

	@available (*, unavailable)
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
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
}

import UIKit

public typealias RegisterableClass = Registerable.Type
public typealias SizeableClass = Sizeable.Type

public protocol Registerable: AnyObject {
	static func identifier() -> String
	static func nib() -> UINib?
}

public protocol IHaveHeight: AnyObject {
	static func internalHeight(with viewModel: BaseCellVM, width: CGFloat) -> CGFloat
	static func internalEstimatedHeight(with viewModel: BaseCellVM) -> CGFloat
}

public protocol Sizeable {
	static func size() -> CGSize
}

public extension UITableView {

	func register(cell: RegisterableClass) {
		guard let cellClass = cell as? UITableViewCell.Type else {
			assertionFailure("Can't register cell class \(String(describing: cell))")
			return
		}

		let identifier = cell.identifier()
		if let nib = cell.nib() {
			self.register(nib, forCellReuseIdentifier: identifier)
		} else {
			self.register(cellClass, forCellReuseIdentifier: identifier)
		}
	}

	func register(header: RegisterableClass) {
		guard let cellClass = header as? UITableViewHeaderFooterView.Type else {
			assertionFailure("Can't register cell class \(String(describing: header))")
			return
		}

		let identifier = header.identifier()
		self.register(cellClass, forHeaderFooterViewReuseIdentifier: identifier)
	}

	func register(cells: RegisterableClass...) {
		self.register(cells: cells)
	}

	func register(cells: [RegisterableClass]) {
		for cell in cells {
			self.register(cell: cell)
		}
	}

	func register(headers: RegisterableClass...) {
		self.register(headers: headers)
	}
	func register(headers: [RegisterableClass]) {
		for header in headers {
			self.register(header: header)
		}
	}

}

open class BaseCell<TViewModel: BaseCellVM>: UITableViewCell, Registerable, IHaveHeight, IHaveViewModel, ViewModelChangedDelegate {

	open override class var requiresConstraintBasedLayout: Bool { true }

	open var viewModelObject: BaseVM? {
		didSet {
			if oldValue?.didChangeDelegate === self {
				oldValue?.didChangeDelegate = nil
			}
			self.viewModelObject?.didChangeDelegate = self

			self.viewModelChanged()
		}
	}

	public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}

	@available(*, unavailable)
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private var constraintsCreated = false

	public static func internalHeight(with viewModel: BaseCellVM, width: CGFloat) -> CGFloat {
		guard let vm = viewModel as? TViewModel else { return UITableView.automaticDimension }
		return self.height(with: vm, width: width)
	}
	public static func internalEstimatedHeight(with viewModel: BaseCellVM) -> CGFloat {
		guard let vm = viewModel as? TViewModel else { return 100 }
		return self.estimatedHeight(with: vm)
	}

	open class func height(with viewModel: TViewModel, width: CGFloat) -> CGFloat {
		return UITableView.automaticDimension
	}

	open class func estimatedHeight(with viewModel: TViewModel) -> CGFloat {
		return 50
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

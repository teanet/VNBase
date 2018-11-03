import Foundation

public typealias RegisterableClass = Registerable.Type
public typealias SizeableClass = Sizeable.Type

public protocol Registerable: AnyObject {
	static func identifier() -> String
	static func nib() -> UINib?
}

public protocol IHaveHeight: AnyObject {
    static func internalHeight(with viewModel: BaseCellVM, width: CGFloat) -> CGFloat
}

public protocol Sizeable {
	static func size() -> CGSize
}

public extension UITableView {

	public func register(cell: RegisterableClass) {
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

	public func register(header: RegisterableClass) {
		guard let cellClass = header as? UITableViewHeaderFooterView.Type else {
			assertionFailure("Can't register cell class \(String(describing: header))")
			return
		}

		let identifier = header.identifier()
		self.register(cellClass, forHeaderFooterViewReuseIdentifier: identifier)
	}

	public func register(cells: RegisterableClass...) {
		self.register(cells: cells)
	}

	public func register(cells: [RegisterableClass]) {
		for cell in cells {
			self.register(cell: cell)
		}
	}

	public func register(headers: RegisterableClass...) {
		self.register(headers: headers)
	}
	public func register(headers: [RegisterableClass]) {
		for header in headers {
			self.register(header: header)
		}
	}

}

open class BaseCell<TViewModel: BaseCellVM>: UITableViewCell, Registerable, IHaveHeight, IHaveViewModel, ViewModelChangedDelegate {

	var viewModelObject: BaseVM? {
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

		self.separatorInset = .zero
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

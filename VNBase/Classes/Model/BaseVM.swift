open class BaseVM: NSObject {
	// swiftlint:disable:next nsobject_prefer_isequal
	public static func == (lhs: BaseVM, rhs: BaseVM) -> Bool {
		return lhs === rhs
	}

	weak var didChangeDelegate: ViewModelChangedDelegate?

	/**
	Вызывается при изменении любого свойства вьюмодели.
	*/
	open func viewModelChanged() {
		self.didChangeDelegate?.viewModelChanged()
	}

}

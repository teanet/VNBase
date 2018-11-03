open class BaseVM: NSObject {
	public static func ==(lhs: BaseVM, rhs: BaseVM) -> Bool {
		return lhs === rhs
	}

	internal weak var didChangeDelegate: ViewModelChangedDelegate?

	/**
	Вызывается при изменении любого свойства вьюмодели.
	*/
	open func viewModelChanged() {
		self.didChangeDelegate?.viewModelChanged()
	}

}

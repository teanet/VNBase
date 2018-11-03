open class BaseViewControllerVM: BaseVM {

	public var title: String?
	public private(set) var isLoaded: Bool = false
	public private(set) var isVisible: Bool = false
	public private(set) var isActive: Bool = false
	public let onLoading = Event<Bool>()

	/**
	Связано с событием viewDidLoad вьюконтроллера. Вызывается один раз в начале жизненного цикла вьюмодели.
	Наследникам рекомендуется в этом методе реализовывать логику, которая должна быть выполнена один раз,
	например, стартовать асинхронную загрузку данных.
	*/
	func load() {
	}

	/**
	Связано с событием viewWillAppear вьюконтроллера. Может вызываться множество раз в течении жизненного цикла вьюмодели.
	Наследникам рекомендуется в этом методе реализовывать логику, которая должна выполняться каждый раз при показе вьюконтроллера,
	например, трекать аналитику показа экрана.
	*/
	func appear() {
	}

	/**
	Связано с событием viewDidAppear вьюконтроллера. Может вызываться множество раз в течении жизненного цикла вьюмодели.
	Наследникам рекомендуется в этом методе реализовывать логику, которая должна выполняться после того, как вьюконтроллер
	будет полностью показан.
	*/
	func didAppear() {
	}

	/**
	Связано с событием viewWillDisappear вьюконтроллера. Может вызываться множество раз в течении жизненного цикла вьюмодели.
	*/
	func disappear() {
	}


	/**
	Вызывается, когда экран появляется в стеке навигации (то есть, его VC есть в UINavigationController.viewControllers).
	*/
	func appearInStack() {
	}


	/**
	Вызывается, когда экран пропадает из стека навигации (то есть, в массиве UINavigationController.viewControllers нет его VC).
	*/
	func disappearInStack() {
	}


	/**
	Связано с событием UIApplicationDidBecomeActive приложения. Может вызываться множество раз в течении жизненного цикла вьюмодели.
	Наследникам рекомендуется в этом методе реализовывать логику обновления состояния вьюмодели,
	которое могло устареть, пока потоки приложения были приостановлены системой,
	например, запросить новые сообщения с сервера, обновить счетчики, etc.
	*/
	func becomeActive() {
	}


	/**
	Связано с событием UIApplicationWillResignActive приложения. Может вызываться множество раз в течении жизненного цикла вьюмодели.
	После вызова этого метода потоки приложения могут быть приостановлены системой.
	*/
	func resignActive() {
	}

	@objc open func reload() {
	}

}

extension BaseViewControllerVM {

	open var screenName: String {
		return NSStringFromClass(type(of: self))
	}

	private var screenClass: String {
		return NSStringFromClass(type(of: self))
	}

}

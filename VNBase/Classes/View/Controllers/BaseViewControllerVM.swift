import UIKit
import VNEssential

open class BaseViewControllerVM: BaseVM {

	public enum State {
		case none
		case willAppear
		case didAppear
		case willDissapear
		case didDissapear
	}

	open var screenName: String {
		return NSStringFromClass(type(of: self))
	}

	public var title: String?
	public private(set) var isAppearAtLeastOnce: Bool = false
	public private(set) var viewModelState: State = .none
	public let onLoading = Event<Bool>()
	private var isAppearFirstTime = false

	open func load() {
	}

	open func appear() {
		self.viewModelState = .willAppear
		if !self.isAppearFirstTime {
			self.isAppearFirstTime = true
			self.appearFirstTime()
		}
	}

	open func didAppear() {
		self.viewModelState = .didAppear
	}

	open func disappear() {
		self.viewModelState = .willDissapear
	}

	open func didDisappear() {
		self.viewModelState = .didDissapear
	}

	/**
	Вызывается, когда экран появляется в стеке навигации (то есть, его VC есть в UINavigationController.viewControllers).
	*/
	open func appearInStack() {
	}

	open func appearFirstTime() {
	}

	/**
	Вызывается, когда экран пропадает из стека навигации (то есть, в массиве UINavigationController.viewControllers нет его VC).
	*/
	open func disappearInStack() {
	}

	/**
	Связано с событием UIApplicationDidBecomeActive приложения. Может вызываться множество раз в течении жизненного цикла вьюмодели.
	Наследникам рекомендуется в этом методе реализовывать логику обновления состояния вьюмодели,
	которое могло устареть, пока потоки приложения были приостановлены системой,
	например, запросить новые сообщения с сервера, обновить счетчики, etc.
	*/
	open func becomeActive() {
	}

	/**
	Связано с событием UIApplicationWillResignActive приложения. Может вызываться множество раз в течении жизненного цикла вьюмодели.
	После вызова этого метода потоки приложения могут быть приостановлены системой.
	*/
	open func resignActive() {
	}

	@objc open func reload() {
	}

}

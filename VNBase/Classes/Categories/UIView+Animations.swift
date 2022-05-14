import UIKit

@objc public extension UIView {
	/// Синтаксический сахар
	///
	/// Метод используется чтобы каждый раз не писать портянку проверок
	/// 
	///     if animated {
	///         UIView.animation(block)
	///     } else {
	///         block()
	///     }
	///
	/// - Parameters:
	///   - animated: выполнять animations в анимационном блоке или нет
	class func performAnimated(
		_ animated: Bool,
		withDuration duration: TimeInterval,
		delay: TimeInterval = 0,
		options: UIView.AnimationOptions = [],
		animations: @escaping () -> Void,
		completion: ((Bool) -> Void)? = nil
	) {
		if animated {
			self.animate(
				withDuration: duration,
				delay: delay,
				options: options,
				animations: animations,
				completion: completion
			)
		} else {
			animations()
			completion?(true)
		}
	}
}

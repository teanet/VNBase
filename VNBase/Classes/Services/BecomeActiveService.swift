import UIKit
import VNEssential

public protocol IBecomeActiveService {
	var onActive: Event<Bool> { get }
	var isActive: Bool { get }
}

public final class BecomeActiveService: NSObject, IBecomeActiveService {

	public let onActive = Event<Bool>()
	public private(set) var isActive: Bool {
		didSet {
			guard oldValue != self.isActive else { return }
			self.onActive.raise(self.isActive)
		}
	}
	private var observers = [NSObjectProtocol]()

	deinit {
		for observer in self.observers {
			NotificationCenter.default.removeObserver(observer)
		}
	}

	public override init() {
		self.isActive = UIApplication.shared.applicationState == .active
		super.init()

		self.observers ++= NotificationCenter.default.addObserver(
			forName: UIApplication.didBecomeActiveNotification,
			object: nil,
			queue: .main
		) { [weak self] _ in
			self?.isActive = true
		}
		self.observers ++= NotificationCenter.default.addObserver(
			forName: UIApplication.willResignActiveNotification,
			object: nil,
			queue: .main
		) { [weak self] _ in
			self?.isActive = false
		}
	}

}

import Foundation

private struct LockWrapper {
	fileprivate static let lockQueue = DispatchQueue(label: "com.grymmobile.vncommon.event.lockqueue")
}

final class EventHandler<TArgs>: Hashable {

	weak var target: AnyObject?
	var actions: [Event<TArgs>.Action]

	private let uuid = UUID()

	required init(target: AnyObject, action: @escaping Event<TArgs>.Action) {
		self.actions = [action]
		self.target = target
	}

	convenience init(tuple: Event<TArgs>.Element) {
		self.init(target: tuple.target, action: tuple.action)
	}

	func add(action: @escaping Event<TArgs>.Action) {
		self.actions.append(action)
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(self.uuid)
	}

	static func == (lhs: EventHandler, rhs: EventHandler) -> Bool {
		return lhs.target === rhs.target
	}

}

public struct Dispatcher: IDispatcher {
	public func async(_ block: @escaping VoidBlock) {
		self.queue.async(execute: block)
	}

	public func sync(_ block: VoidBlock) {
		self.queue.sync(execute: block)
	}

	private let queue: DispatchQueue

	public init(queue: DispatchQueue) {
		self.queue = queue
	}

	public static let main = Dispatcher(queue: DispatchQueue.main)
}

public class Event<TArgs> {

	public typealias Action = (TArgs) -> Void
	public typealias Element = (target: AnyObject, action: Action)

	var handlers = Set<EventHandler<TArgs>>()

	private let shouldReplayLast: Bool
	private var lastValue: TArgs?

	private var filter: ((TArgs) -> Bool)?

	public init(shouldReplayLast: Bool = false) {
		self.shouldReplayLast = shouldReplayLast
	}

	// MARK: - Public

	/// Подписаться на событие
	/// - Parameters:
	///   - target: тот, на ком завязана эта подписка, в случае смерти, будет автоматически отписан и сообщения посылаться не будут
	///   - dispatcher: очередь, на которой будем стрелять action блоком,
	///   если передать nil будет вызвано на том же потоке что и была подписка
	///   - action: блок иполнения
	public func add(
		_ target: AnyObject,
		dispatcher: IDispatcher? = Dispatcher.main,
		action: @escaping Action
	) {
		self.add(target) { (args) in
			if let dispatcher = dispatcher {
				dispatcher.async {
					action(args)
				}
			} else {
				action(args)
			}
		}
	}

	private func add(_ target: AnyObject, action: @escaping Action) {
		self.add(handler: (target: target, action: action))
	}

	public func filter(_ filter: @escaping ((TArgs) -> Bool)) -> Event<TArgs> {
		self.filter = filter

		return self
	}

	public func raise(_ args: TArgs) {
		guard self.checkRaiseFilter(args: args) else { return }

		if self.shouldReplayLast {
			var prevLastValue: TArgs?
			LockWrapper.lockQueue.sync {
				prevLastValue = self.lastValue
				self.lastValue = args
			}

			// Отпустить старый объект можно только вне блокировки,
			// в противном случае может быть потенциальный deadlock или crash
			weak var _ = prevLastValue // чтобы избежать ворнинг `variable was written to but never read`
			prevLastValue = nil
		}

		let handlers = LockWrapper.lockQueue.sync { return self.handlers }
		for handler in handlers {
			for action in handler.actions {
				action(args)
			}
		}
	}

	private func add(handler: Element) {
		LockWrapper.lockQueue.sync {
			self.removeDeadHandlers()
			var eventHandler = self.eventHandler(by: handler.target)
			if eventHandler == nil {
				eventHandler = EventHandler<TArgs>(tuple: handler)
				self.handlers.insert(eventHandler!)
			} else {
				eventHandler?.add(action: handler.action)
			}
		}

		if self.shouldReplayLast,
			let lastValue = LockWrapper.lockQueue.sync(execute: { self.lastValue }) {
			handler.action(lastValue)
		}
	}

	public func remove(target: AnyObject) {
		LockWrapper.lockQueue.sync {
			let handlers = self.handlers
			for handler in handlers {
				if handler.target == nil || handler.target === target {
					self.handlers.remove(handler)
				}
			}
		}
	}

	// MARK: Operators

	public static func += (left: Event<TArgs>, right: Element) {
		left.add(handler: right)
	}

	public static func -= (left: Event<TArgs>, right: AnyObject) {
		left.remove(target: right)
	}

	// MARK: - Private

	private func checkRaiseFilter(args: TArgs) -> Bool {
		var result = false
		if let filter = self.filter {
			result = filter(args)
		} else {
			result = true
		}

		return result
	}

	private func removeDeadHandlers() {
		let handlers = self.handlers
		for handler in handlers where handler.target == nil {
			self.handlers.remove(handler)
		}
	}

	private func eventHandler(by target: AnyObject) -> EventHandler<TArgs>? {
		var result: EventHandler<TArgs>?
		let handlers = self.handlers
		for handler in handlers {
			// swiftlint:disable:next for_where
			if handler.target === target {
				result = handler
				break
			}
		}
		return result
	}

}

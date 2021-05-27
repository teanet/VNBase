import Foundation
import VNEssential

public final class Lazy<T>: IInvalidating {

	public var isInitialized: Bool {
		return _value != nil
	}
	private let factory: () -> T

	private var _value: T?
	public var value: T {
		let value = _value ?? self.factory()
		_value = value
		return value
	}

	public init(_ factory: @escaping () -> T) {
		self.factory = factory
	}

	public func invalidate() {
		_value = nil
	}
}

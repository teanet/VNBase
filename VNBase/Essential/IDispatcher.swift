public protocol IDispatcher {
	func async(_ block: @escaping VoidBlock)
	func sync(_ block: @escaping VoidBlock)
}

import Foundation
import VNEssential

public extension Thread {

	static func runOnMain(withAssert: Bool = true, block: @escaping VoidBlock) {
		if Thread.isMainThread {
			block()
		} else {
			if withAssert {
				assertionFailure("Method should be called only on the Main Thread")
			}
			DispatchQueue.main.async(execute: block)
		}
	}

}

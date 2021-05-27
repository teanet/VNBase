import Foundation

public extension Data {
	func pushToken() -> String {
		let token = self.map({ String(format: "%02.2hhx", $0)}).joined()
		return token
	}
}

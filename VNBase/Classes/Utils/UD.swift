import Foundation

@propertyWrapper
// swiftlint:disable:next type_name
public struct UD<T: Codable> {

	private let key: String
	private let defaultValue: T

	public init(wrappedValue initialValue: T, key: String) {
		self.key = key
		self.defaultValue = initialValue
	}

	public var wrappedValue: T {
		get {
			guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
				return self.defaultValue
			}
			let value = try? JSONDecoder().decode(T.self, from: data)
			return value ?? self.defaultValue
		}
		set {
			let data = try? JSONEncoder().encode(newValue)
			UserDefaults.standard.set(data, forKey: self.key)
		}
	}

}

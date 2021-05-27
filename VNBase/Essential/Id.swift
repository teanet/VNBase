import Foundation

open class Id<T: Hashable&Codable>:
	RawRepresentable,
	Hashable,
	Codable,
	CustomStringConvertible,
	CustomDebugStringConvertible {

	public required init(rawValue: T) {
		self.rawValue = rawValue
	}
	public convenience init(_ rawValue: T) {
		self.init(rawValue: rawValue)
	}
	public var rawValue: T

	public typealias RawValue = T

	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.rawValue.hashValue)
	}

	public static func == (lhs: Id, rhs: Id) -> Bool {
		return lhs.rawValue == rhs.rawValue
	}

	public required init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let value = try container.decode(T.self)
		self.rawValue = value
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(self.rawValue)
	}

	public var description: String {
		return "\(self.rawValue)"
	}

	public var debugDescription: String {
		return "\(self.rawValue)"
	}

}

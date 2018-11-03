extension String { // + HTML

	internal var html: NSAttributedString {
		guard let data = self.data(using: .utf8) else { return NSAttributedString() }
		do {
			return try NSAttributedString(data: data, options: [
				.documentType: NSAttributedString.DocumentType.html,
				.characterEncoding: String.Encoding.utf8.rawValue
			], documentAttributes: nil)
		} catch {
			return NSAttributedString()
		}
	}

	internal var trimmed: String
	{
		let trimmedString = self.trimmingCharacters(in: .whitespacesAndNewlines)
		return trimmedString
	}

}

public extension String {

	public var selfOrNilIfEmptyOrAllWhitespaces: String? {
		let nilOrSelfString = String.isNilOrEmptyOrAllWhitespaces(string: self) ? nil : self
		return nilOrSelfString
	}

	public static func isNilOrEmptyOrAllWhitespaces(string: String?) -> Bool {
		guard let string = string,
			!string.isEmpty,
			// удаляем все пробелы
			!string.components(separatedBy: .whitespaces).joined().isEmpty
			else { return true }

		return false
	}

	public static func trim(string: String, lengthLimit: UInt) -> String {
		let suitableTextIndex = string.index(string.startIndex, offsetBy: Swift.min(string.count, Int(lengthLimit)))

		return String(string.prefix(upTo: suitableTextIndex))
	}

	public func condenseWhitespace() -> String {
		return self.components(separatedBy: .whitespacesAndNewlines)
			.filter { !$0.isEmpty }
			.joined(separator: " ")
	}

}

public extension Optional where Wrapped == String {

	public func isNilOrEmptyOrAllWhitespace() -> Bool {
		guard let string = self,
			!string.isEmpty,
			//удаляем все пробелы
			!string.components(separatedBy: .whitespaces).joined().isEmpty
			else { return true }

		return false
	}

	public func width(
		constrainedHeight height: CGFloat,
		drawingOptions: NSStringDrawingOptions = .usesLineFragmentOrigin,
		font: UIFont
		) -> CGFloat {
		guard let this = self else { return 0.0 }

		let value = this.width(constrainedHeight: height, drawingOptions: drawingOptions, font: font)

		return value
	}

	public func height(
		constrainedWidth width: CGFloat,
		drawingOptions: NSStringDrawingOptions = .usesLineFragmentOrigin,
		font: UIFont
		) -> CGFloat {
		guard let this = self, !this.isEmpty else { return 0.0 }

		let value = this.height(constrainedWidth: width, drawingOptions: drawingOptions, font: font)

		return value
	}

	public func size(
		constrainedSize size: CGSize,
		drawingOptions: NSStringDrawingOptions = .usesLineFragmentOrigin,
		font: UIFont
		) -> CGRect {
		guard let this = self else { return .zero }

		let value = this.size(constrainedSize: size, drawingOptions: drawingOptions, font: font)

		return value
	}

}

public extension String {

	public func width(
		constrainedHeight height: CGFloat,
		drawingOptions: NSStringDrawingOptions = .usesLineFragmentOrigin,
		font: UIFont
		) -> CGFloat {

		let constraintSize = CGSize(width: .greatestFiniteMagnitude, height: height)
		let boundingBox = self.size(
			constrainedSize: constraintSize,
			drawingOptions: drawingOptions,
			font: font
		)

		return boundingBox.width
	}

	public func height(
		constrainedWidth width: CGFloat,
		drawingOptions: NSStringDrawingOptions = .usesLineFragmentOrigin,
		font: UIFont
		) -> CGFloat {

		let constraintSize = CGSize(width: width, height: .greatestFiniteMagnitude)
		let boundingBox = self.size(
			constrainedSize: constraintSize,
			drawingOptions: drawingOptions,
			font: font
		)

		return boundingBox.height
	}

	public func size(
		constrainedSize size: CGSize,
		drawingOptions: NSStringDrawingOptions = .usesLineFragmentOrigin,
		font: UIFont
		) -> CGRect {

		let boundingBox = self.boundingRect(
			with: size,
			options: drawingOptions,
			attributes: [
				.font: font
			],
			context: nil
		)

		return boundingBox
	}
}

public extension String {

	public static var space = " "

	public var first: String {
		return String(self.prefix(1))
	}

	public var last: String {
		return String(self.suffix(1))
	}

	public func uppercasedFirst() -> String {
		let chars = self.dropFirst()
		return self.first.uppercased() + String(chars)
	}

	public func lowercasedFirst() -> String {
		let chars = self.dropFirst()
		return self.first.lowercased() + String(chars)
	}
}

public extension String {

	public func withExt(ext: String?, delimeter: String) -> String {
		guard let ext = ext else { return self }
		return self + delimeter + ext
	}

}

public extension String {

	public var isValidEmail: Bool {
		let emailRegEx = "[A-Z0-9a-zA-Яа-я._%+-]+@[A-Za-z0-9A-Яа-я.-]+\\.[A-Za-zA-Яа-я]{2,4}"
		let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		let result = emailTest.evaluate(with: self)

		return result
	}

}


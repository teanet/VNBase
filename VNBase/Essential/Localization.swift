import Foundation

public class Testing {
	public static var isUnitTest = false
}

// swiftlint:disable:next identifier_name
public func L10N(_ string: String) -> String {
	if Testing.isUnitTest {
		return string
	} else {
		return NSLocalizedString(string, comment: "")
	}
}

// swiftlint:disable:next identifier_name
public func L18N(_ format: String, value: Int) -> String {
	if Testing.isUnitTest {
		return format
	} else {
		let format = NSLocalizedString(format, comment: "")
		return String(format: format, locale: Locale.current, value)
	}
}

public extension String {

	func l10n() -> String {
		return L10N(self)
	}

}

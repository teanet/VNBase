import Foundation

public class Config {
	public static var disableLocalization = false
	public static var bundle: Bundle = .main
}

// swiftlint:disable:next identifier_name
public func L10N(_ string: String) -> String {
	if Config.disableLocalization {
		return string
	} else {
		return NSLocalizedString(string, bundle: Config.bundle, comment: "")
	}
}

// swiftlint:disable:next identifier_name
public func L18N(_ format: String, value: Int) -> String {
	if Config.disableLocalization {
		return format
	} else {
		let format = NSLocalizedString(format, bundle: Config.bundle, comment: "")
		return String(format: format, locale: Locale.current, value)
	}
}

public extension String {

	func l10n() -> String {
		return L10N(self)
	}

}

var isUnitTest = false

func L10N(_ string: String) -> String {
	if isUnitTest {
		return string
	} else {
		return NSLocalizedString(string, comment: "")
	}
}

func L18N(_ format: String, value: Int) -> String {
	if isUnitTest {
		return format
	} else {
		let format = NSLocalizedString(format, comment: "")
		return String(format: format, locale: Locale.current, value)
	}
}

extension String {

	func l10n() -> String {
		return L10N(self)
	}

}

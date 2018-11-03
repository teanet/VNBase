internal struct Constants
{
	static let baseUrlString: String = {
		#if DEBUG
		return "https://vyrtystage-netcore2.azurewebsites.net"
		#else
		return "https://vyrtystage-netcore2.azurewebsites.net"
		#endif
	}()
	static let timeoutIntervalForRequest: TimeInterval = {
		#if DEBUG
		return 30
		#else
		return 30
		#endif
	}()

	static let currentVersion = Bundle.main.infoDictionary?[String(kCFBundleVersionKey)]! as! String
	static let currentBuild = Bundle.main.infoDictionary?["CFBundleShortVersionString"]! as! String
	static let mobilePlatformModel = UIDeviceHardware.platformModelString()
	static let mobilePlatformVerboseModel = UIDeviceHardware.platformString()
	static let mobileOSName = "ios"
	static let mobileVendorName = "Apple"
	static let platformOSVersion = UIDevice.current.systemVersion
	static let currentLanguage = Locale.preferredLanguages.first ?? "ru-RU"
	static let currentLocale = Locale.current.identifier
	static let currentTimeZone = TimeZone.current.identifier
	static let logFileName = "vyrty.log"
	static let feedbackEmail = "badimm.235@gmail.com"

	static let phoneMask = "{+1} [000] [000]-[0000]"
	static let codeMask = "[000000]"
}

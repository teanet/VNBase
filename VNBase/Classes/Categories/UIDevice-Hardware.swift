import UIKit

public struct UIDeviceHardware {
	public static func platformModelString() -> String {
		if let key = "hw.machine".cString(using: String.Encoding.utf8) {
			var size: Int = 0
			sysctlbyname(key, nil, &size, nil, 0)
			var machine = [CChar](repeating:     0, count:     Int(size))
			sysctlbyname(key, &machine, &size, nil, 0)
			return String(cString: machine)
		}

		return "Unknown"
	}

	public static func platformString() -> String {
		switch UIDeviceHardware.platformModelString() {
			case "iPhone1,1":   				return "iPhone 1G"
			case "iPhone1,2":   				return "iPhone 3G"
			case "iPhone2,1":   				return "iPhone 3GS"
			case "iPhone3,1":   				return "iPhone 4"
			case "iPhone3,3":   				return "VerizoniPhone 4"
			case "iPhone4,1":   				return "iPhone 4S"
			case "iPhone5,1":   				return "iPhone 5 (GSM)"
			case "iPhone5,2":   				return "iPhone 5 (GSM+CDMA)"
			case "iPhone5,3":   				return "iPhone 5c (GSM)"
			case "iPhone5,4":   				return "iPhone 5c (GSM+CDMA)"
			case "iPhone6,1":   				return "iPhone 5s (GSM)"
			case "iPhone6,2":   				return "iPhone 5s (GSM+CDMA)"
			case "iPhone7,2":   				return "iPhone 6"
			case "iPhone7,1":   				return "iPhone 6 Plus"
			case "iPhone8,1":	 				return "iPhone 6s"
			case "iPhone8,2":	 				return "iPhone 6s Plus"
			case "iPhone8,4":	 				return "iPhone SE"
			case "iPhone9,1":	 				return "iPhone 7"
			case "iPhone9,2":	 				return "iPhone 7 Plus"
			case "iPhone9,3":	 				return "iPhone 7"
			case "iPhone9,4":	 				return "iPhone 7 Plus"
			case "iPhone10,1":	 				return "iPhone 8"
			case "iPhone10,4":	 				return "iPhone 8"
			case "iPhone10,2":	 				return "iPhone 8 Plus"
			case "iPhone10,5":	 				return "iPhone 8 Plus"
			case "iPhone10,3", "iPhone10,6": 	return "iPhone X"
			case "iPhone11,2":                	return "iPhone XS"
			case "iPhone11,4", "iPhone11,6":  	return "iPhone XS Max"
			case "iPhone11,8":                	return "iPhone XR"
			case "iPhone12,1":                	return "iPhone 11"
			case "iPhone12,3":                	return "iPhone 11 Pro"
			case "iPhone12,5":                	return "iPhone 11 Pro Max"

			case "iPod1,1":     return "iPod Touch 1G"
			case "iPod2,1":     return "iPod Touch 2G"
			case "iPod3,1":     return "iPod Touch 3G"
			case "iPod4,1":     return "iPod Touch 4G"
			case "iPod5,1":     return "iPod Touch 5G"
			case "iPod7,1":     return "iPod Touch 6G"
			case "iPad1,1":     return "iPad"
			case "iPad2,1":     return "iPad 2 (WiFi)"
			case "iPad2,2":     return "iPad 2 (GSM)"
			case "iPad2,3":     return "iPad 2 (CDMA)"
			case "iPad2,4":     return "iPad 2 (WiFi)"
			case "iPad2,5":     return "iPad Mini (WiFi)"
			case "iPad2,6":     return "iPad Mini (GSM)"
			case "iPad2,7":     return "iPad Mini (GSM+CDMA)"
			case "iPad3,1":     return "iPad 3 (WiFi)"
			case "iPad3,2":     return "iPad 3 (GSM+CDMA)"
			case "iPad3,3":     return "iPad 3 (GSM)"
			case "iPad3,4":     return "iPad 4 (WiFi)"
			case "iPad3,5":     return "iPad 4 (GSM)"
			case "iPad3,6":     return "iPad 4 (GSM+CDMA)"
			case "iPad4,1":     return "iPad Air (WiFi)"
			case "iPad4,2":     return "iPad Air (Cellular)"
			case "iPad4,3":     return "iPad Air"
			case "iPad4,4":     return "iPad Mini 2G (WiFi)"
			case "iPad4,5":     return "iPad Mini 2G (Cellular)"
			case "iPad4,6":     return "iPad Mini 2G"
			case "iPad4,7":     return "iPad Mini 3 (WiFi)"
			case "iPad4,8":     return "iPad Mini 3 (Cellular)"
			case "iPad4,9":     return "iPad Mini 3 (China)"
			case "iPad5,3":     return "iPad Air 2 (WiFi)"
			case "iPad5,4":     return "iPad Air 2 (Cellular)"
			case "iPad6,7":     return "iPad Pro (12,9 inch)"
			case "iPad6,8":     return "iPad Pro (12,9 inch)"
			case "iPad6,3":     return "iPad Pro (9,7 inch)"
			case "iPad6,4":     return "iPad Pro (9,7 inch)"
			case "iPad6,11":     return "iPad 5"
			case "iPad6,12":     return "iPad 5"
			case "iPad7,1":     return "iPad Pro 2 (12,9 inch)"
			case "iPad7,2":     return "iPad Pro 2 (12,9 inch)"
			case "iPad7,3":     return "iPad Pro (10,5 inch)"
			case "iPad7,4":     return "iPad Pro (10,5 inch)"
			case "iPad7,5":     return "iPad 5"
			case "iPad7,6":     return "iPad 5"
			case "AppleTV2,1":  return "Apple TV 2G"
			case "AppleTV3,1":  return "Apple TV 3"
			case "AppleTV3,2":  return "Apple TV 3 (2013)"
			case "i386":        return "iPhone Simulator"
			case "x86_64":      return "iPhone Simulator"
			default:            return "Unknown iOS"
		}
	}

}

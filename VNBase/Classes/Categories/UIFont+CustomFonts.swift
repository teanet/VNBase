internal extension UIFont { // + CustomFonts

	static func displayBoldFont(of size: CGFloat) -> UIFont {
		let font = UIFont.boldSystemFont(ofSize: size)
		return font
	}

	static func displayFont(of size: CGFloat) -> UIFont {
		let font = UIFont.systemFont(ofSize: size)
		return font
	}

	static func avenirDemiBold(of size: CGFloat) -> UIFont {
		return UIFont(name: "AvenirNext-DemiBold", size: size)!
	}

	static func avenirRegular(of size: CGFloat) -> UIFont {
		return UIFont(name: "AvenirNext-Regular", size: size)!
	}

	static func avenirMedium(of size: CGFloat) -> UIFont {
		return UIFont(name: "AvenirNext-Medium", size: size)!
	}

	static func sfProDisplayM(of size: CGFloat) -> UIFont {
		return UIFont(name: "SFProDisplay-Medium", size: size)!
	}
	static func sfProDisplayR(of size: CGFloat) -> UIFont {
		return UIFont(name: "SFProDisplay-Regular", size: size)!
	}
	static func sfProDisplayB(of size: CGFloat) -> UIFont {
		return UIFont(name: "SFProDisplay-Bold", size: size)!
	}
	static func sfUIDisplayR(of size: CGFloat) -> UIFont {
		return UIFont(name: "SFUIDisplay-Regular", size: size)!
	}
	static func sfUIDisplayM(of size: CGFloat) -> UIFont {
		return UIFont(name: "SFUIDisplay-Medium", size: size)!
	}
	static func sfProTextR(of size: CGFloat) -> UIFont {
		return UIFont(name: "SFProText-Regular", size: size)!
	}
	static func sfProTextB(of size: CGFloat) -> UIFont {
		return UIFont(name: "SFProText-Bold", size: size)!
	}

	static func listOfFonts() {
		var output = ""
		for familyName in UIFont.familyNames {
			let title = "Family name: \(familyName)"
			let content = "Fonts: \(UIFont.fontNames(forFamilyName: familyName))"
			output = output + "\n" + title + "\n" + content + "\n"
		}
		print(">>> \(output)")
	}

}

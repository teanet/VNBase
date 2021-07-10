import Foundation
import UIKit

public struct ImageWithTint {
	public let image: UIImage?
	public let tint: UIColor?

	public init(_ image: UIImage?, tint: UIColor? = nil) {
		self.image = image
		self.tint = tint
	}

}

public extension ImageWithTint {
	static func named(_ imageName: String) -> ImageWithTint {
		self.init(.named(imageName), tint: nil)
	}
	static func templatedNamed(_ imageName: String, tint: UIColor) -> ImageWithTint {
		self.init(.templatedNamed(imageName), tint: tint)
	}
}

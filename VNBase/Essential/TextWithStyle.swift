import Foundation

public struct TextWithStyle {
	public let text: String
	public let style: TextStyle
	public let disabled: TextStyle?

	public init(text: String, style: TextStyle, disabled: TextStyle? = nil) {
		self.text = text
		self.style = style
		self.disabled = disabled
	}
}

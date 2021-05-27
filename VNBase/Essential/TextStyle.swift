import UIKit

public struct TextStyle {
	public var font: UIFont
	public var interLetterSpacing: CGFloat
	public var color: UIColor
	public var lineHeight: CGFloat = 0
	public var underlineStyle: NSUnderlineStyle
	public var strikethroughStyle: NSUnderlineStyle?
	public var strikethroughColor: UIColor?

	public init(
		font: UIFont,
		color: UIColor = .white,
		interLetterSpacing: CGFloat = 0,
		lineHeight: CGFloat = 0,
		underlineStyle: NSUnderlineStyle = NSUnderlineStyle(rawValue: 0),
		strikethroughStyle: NSUnderlineStyle? = nil,
		strikethroughColor: UIColor? = nil
	) {
		self.font = font
		self.color = color
		self.interLetterSpacing = interLetterSpacing
		self.lineHeight = lineHeight
		self.underlineStyle = underlineStyle
		self.strikethroughStyle = strikethroughStyle
		self.strikethroughColor = strikethroughColor
	}

}

public extension TextStyle {

	func with(_ populator: (inout TextStyle) throws -> Void) rethrows -> TextStyle {
		var style = self
		try populator(&style)
		return style
	}

	func attributedString(
		_ text: String,
		textAlignment: NSTextAlignment = .left,
		lineHeightMultiple: CGFloat? = nil,
		lineBreakMode: NSLineBreakMode = .byTruncatingTail
	) -> NSMutableAttributedString {
		let attributes = self.attributes(
			textAlignment: textAlignment,
			lineHeightMultiple: lineHeightMultiple,
			lineBreakMode: lineBreakMode
		)
		let attributedText = NSMutableAttributedString(string: text, attributes: attributes)
		return attributedText
	}

	func attributes(
		textAlignment: NSTextAlignment = .left,
		lineHeightMultiple: CGFloat? = nil,
		lineBreakMode: NSLineBreakMode = .byTruncatingTail
	) -> [NSAttributedString.Key: Any] {
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.minimumLineHeight = self.lineHeight
		paragraphStyle.maximumLineHeight = self.lineHeight
		paragraphStyle.alignment = textAlignment
		paragraphStyle.lineBreakMode = lineBreakMode
		var attributes: [NSAttributedString.Key: Any] = [
			.font: self.font,
			.paragraphStyle: paragraphStyle,
			.kern: NSNumber(value: Float(self.font.pointSize * self.interLetterSpacing)),
			.foregroundColor: self.color,
			.underlineStyle: self.underlineStyle.rawValue,
		]
		if let strikethroughColor = self.strikethroughColor {
			attributes[.strikethroughColor] = strikethroughColor
		}
		if let strikethroughStyle = self.strikethroughStyle {
			attributes[.strikethroughStyle] = strikethroughStyle.rawValue
		}
		return attributes
	}

}

public extension NSMutableAttributedString {

	@discardableResult
	func with(
		attributes: [NSAttributedString.Key : Any],
		for attributingText: String,
		in text: String
	) -> NSMutableAttributedString {
		self.setAttributes(
			attributes,
			range: (text as NSString).range(of: attributingText)
		)
		return self
	}

}

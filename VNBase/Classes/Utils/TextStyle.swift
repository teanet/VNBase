import UIKit

public struct TextStyle {
	public let font: UIFont
	public let interLetterSpacing: CGFloat
	public var color: UIColor
	public var lineHeight: CGFloat = 0
}

public extension TextStyle {

	func with(_ populator: (inout TextStyle) throws -> ()) rethrows -> TextStyle {
		var style = self
		try populator(&style)
		return style
	}

	func attributedString(
		_ text: String,
		textAlignment: NSTextAlignment = .left,
		lineHeightMultiple: CGFloat? = nil
	) -> NSMutableAttributedString {
		let attributes = self.attributes(textAlignment: textAlignment, lineHeightMultiple: lineHeightMultiple)
		let attributedText = NSMutableAttributedString(string: text, attributes: attributes)
		return attributedText
	}

	func attributes(
		textAlignment: NSTextAlignment = .left,
		lineHeightMultiple: CGFloat? = nil,
		lineBreakMode: NSLineBreakMode = .byTruncatingTail
	) -> [NSAttributedString.Key : Any] {
		let paragraphStyle = NSMutableParagraphStyle()
		if self.lineHeight > 0 {
			paragraphStyle.minimumLineHeight = self.lineHeight
			paragraphStyle.maximumLineHeight = self.lineHeight
		}
		paragraphStyle.alignment = textAlignment
		paragraphStyle.lineBreakMode = lineBreakMode
		if let lineHeightMultiple = lineHeightMultiple {
			paragraphStyle.lineHeightMultiple = lineHeightMultiple
		}
		let attributes: [NSAttributedString.Key : Any] = [
			.font : self.font,
			.paragraphStyle : paragraphStyle,
			.kern: NSNumber(value: Float(self.font.pointSize * self.interLetterSpacing)),
			.foregroundColor: self.color,
		]
		return attributes
	}

}


public extension UIButton {
	func apply(_ style: TextStyle, text: String, state: UIControl.State = .normal) {
		let text = style.attributedString(text, textAlignment: .center)
		self.setAttributedTitle(text, for: state)
	}
}

public extension UILabel {
	func apply(_ style: TextStyle, text: String, textAlignment: NSTextAlignment = .left) {
		self.attributedText = style.attributedString(text, textAlignment: textAlignment)
	}
}

public extension UIBarItem {
	func apply(_ style: TextStyle, state: UIControl.State) {
		let attributes = style.attributes(textAlignment: .center, lineBreakMode: .byWordWrapping)
		self.setTitleTextAttributes(attributes, for: state)
	}
}

public extension UILabel {

	static func label(
		text: String? = nil,
		textAlignment: NSTextAlignment = .left,
		textColor: UIColor = .black,
		font: UIFont = .systemFont(ofSize: 18),
		lineSpacing: CGFloat? = nil
	) -> Self {
		let label = self.init()
		if let lineSpacing = lineSpacing, let text = text {
			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.lineSpacing = lineSpacing
			label.attributedText = NSAttributedString(string: text, attributes: [
				NSAttributedString.Key.paragraphStyle : paragraphStyle
			])
		} else {
			label.text = text
		}
		label.textAlignment = textAlignment
		label.textColor = textColor
		label.font = font
		return label
	}

}

public extension NSMutableAttributedString {

	@discardableResult func imagified(with image: UIImage?, bounds: CGRect) -> NSAttributedString {
		guard let image = image else { return self }
		let image1Attachment = NSTextAttachment()
		image1Attachment.image = image
		image1Attachment.bounds = bounds
		let imageString = NSAttributedString(attachment: image1Attachment)
		self.append(imageString)
		return self
	}

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
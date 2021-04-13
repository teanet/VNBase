import UIKit

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
}

public extension UIButton {

	func apply(
		_ style: TextStyle,
		text: String,
		state: UIControl.State = .normal,
		textAlignment: NSTextAlignment = .center
	) {
		let text = style.attributedString(text, textAlignment: textAlignment)
		self.setAttributedTitle(text, for: state)
	}

	func apply(
		text: String,
		textAlignment: NSTextAlignment = .center,
		normal: TextStyle,
		highlighted: TextStyle? = nil,
		disabled: TextStyle? = nil
	) {
		self.apply(normal, text: text, state: .normal, textAlignment: textAlignment)
		self.apply(
			highlighted ?? normal.with { $0.color = normal.color.withAlphaComponent(0.7) },
			text: text,
			state: .highlighted,
			textAlignment: textAlignment
		)
		self.apply(
			disabled ?? normal.with { $0.color = normal.color.withAlphaComponent(0.3) },
			text: text,
			state: .disabled,
			textAlignment: textAlignment
		)
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
				NSAttributedString.Key.paragraphStyle : paragraphStyle,
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

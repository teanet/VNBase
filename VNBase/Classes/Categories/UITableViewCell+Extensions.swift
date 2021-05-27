import UIKit

public extension UITableViewCell {

	func makeClearBackground(
		color: UIColor = .clear,
		selectedColor: UIColor = .clear
	) {
		self.separatorInset = .dgs_invisibleSeparator
		self.backgroundColor = color
		self.contentView.backgroundColor = color
		self.backgroundView = UIView()
		self.backgroundView?.backgroundColor = color

		self.selectedBackgroundView = UIView()
		self.selectedBackgroundView?.backgroundColor = selectedColor
	}

}

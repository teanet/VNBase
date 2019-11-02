import UIKit

public extension UIImageView {

	func named(_ name: String?) -> UIImageView {
		let image: UIImage? = {
			guard let name = name, !name.isEmpty else { return nil }
			return UIImage(named: name)
		}()
		return UIImageView(image: image)
	}

}

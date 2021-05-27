import UIKit

public extension CGSize {

	static func height(_ height: CGFloat) -> CGSize {
		CGSize(width: UIView.noIntrinsicMetric, height: height)
	}

}

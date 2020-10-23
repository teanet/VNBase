public extension CGSize {

	func height(_ height: CGFloat) -> CGSize {
		CGSize(width: UIView.noIntrinsicMetric, height: height)
	}

}

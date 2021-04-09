public extension Bool {
	var alpha: CGFloat { self ? 1 : 0 }
	var highlightedAlpha: CGFloat { self ? self.highlightedAlpha : 1 }
	var isHiddenAlpha: CGFloat { self ? 0 : 1 }
}

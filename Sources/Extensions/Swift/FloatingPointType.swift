public extension FloatingPointType where Self: Comparable {

	@warn_unused_result
	public func clamp(min min: Self, max: Self) -> Self {
		return Swift.min(Swift.max(self, min), max)
	}
}

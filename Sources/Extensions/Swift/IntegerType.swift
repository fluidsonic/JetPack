public extension Integer where Self: Comparable {

	
	public func clamp(min: Self, max: Self) -> Self {
		return Swift.min(Swift.max(self, min), max)
	}
}

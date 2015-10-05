public extension IntegerType where Self: Comparable {

	@warn_unused_result
	public func clamp(min min: Self, max: Self) -> Self {
		return Swift.min(Swift.max(self, min), max)
	}


	public var sign: Self {
		if self == 0 {
			return 0
		}

		if self < 0 {
			return -1
		}

		return 1
	}
}

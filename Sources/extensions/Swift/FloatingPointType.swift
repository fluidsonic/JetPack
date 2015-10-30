public extension FloatingPointType where Self: Comparable {

	@warn_unused_result
	public func clamp(min min: Self, max: Self) -> Self {
		return Swift.min(Swift.max(self, min), max)
	}


	public var sign: Self {
		let zero = Self(0)

		if isZero {
			return zero
		}

		if self < zero {
			return Self(-1)
		}

		return Self(1)
	}
}

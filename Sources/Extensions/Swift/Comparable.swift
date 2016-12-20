public extension Comparable {

	public func coerced(atLeast minimum: Self) -> Self {
		return max(self, minimum)
	}


	public func coerced(atMost maximum: Self) -> Self {
		return min(self, maximum)
	}


	public func coerced(in range: ClosedRange<Self>) -> Self {
		return coerced(atMost: range.upperBound).coerced(atLeast: range.lowerBound)
	}
}

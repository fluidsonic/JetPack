public extension Comparable {

	@warn_unused_result
	public func coerced(atLeast minimum: Self) -> Self {
		return max(self, minimum)
	}


	@warn_unused_result
	public func coerced(atMost maximum: Self) -> Self {
		return min(self, maximum)
	}


	@warn_unused_result
	public func coerced(in interval: ClosedInterval<Self>) -> Self {
		return coerced(atMost: interval.end).coerced(atLeast: interval.start)
	}
}

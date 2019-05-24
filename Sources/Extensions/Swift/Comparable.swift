public extension Comparable {

	func coerced(atLeast minimum: Self) -> Self {
		return max(self, minimum)
	}


	func coerced(atLeast minimum: Self, atMost maximum: Self) -> Self {
		return coerced(atMost: maximum).coerced(atLeast: minimum)
	}


	func coerced(atMost maximum: Self) -> Self {
		return min(self, maximum)
	}


	func coerced(in range: ClosedRange<Self>) -> Self {
		return coerced(atMost: range.upperBound).coerced(atLeast: range.lowerBound)
	}
}

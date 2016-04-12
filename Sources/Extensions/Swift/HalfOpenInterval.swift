public extension HalfOpenInterval {

	public func subtracting(intervalToSubtract: HalfOpenInterval<Bound>) -> [HalfOpenInterval<Bound>] {
		guard intervalToSubtract.start < end && intervalToSubtract.end > start else {
			return [self]
		}

		var result = Array<HalfOpenInterval<Bound>>()
		if intervalToSubtract.start > start {
			result.append(start ..< intervalToSubtract.start)
		}
		if intervalToSubtract.end < end {
			result.append(intervalToSubtract.end ..< end)
		}

		return result
	}
}

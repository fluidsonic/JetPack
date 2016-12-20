public extension Range where Bound: RandomizableIntegerType {

	public var randomIndex: Bound? {
		let distance = upperBound - lowerBound
		if distance < 0 {
			return nil
		}

		return lowerBound + Bound.random(start: 0, end: distance)
	}
}

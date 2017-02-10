public extension Range {

	public func mapNotNil <T: Comparable>(_ transform: (Bound) -> T?) -> Range<T>? {
		guard
			let lowerBound = transform(lowerBound),
			let upperBound = transform(upperBound),
			lowerBound < upperBound
		else {
				return nil
		}

		return lowerBound ..< upperBound
	}
}


public extension Range where Bound: RandomizableIntegerType {

	public var randomIndex: Bound? {
		let distance = upperBound - lowerBound
		if distance < 0 {
			return nil
		}

		return lowerBound + Bound.random(start: 0, end: distance)
	}
}

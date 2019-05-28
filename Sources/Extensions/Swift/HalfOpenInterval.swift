public extension Range {

	func subtracting(_ rangeToSubtract: Range<Bound>) -> [Range<Bound>] {
		guard rangeToSubtract.lowerBound < upperBound && rangeToSubtract.upperBound > lowerBound else {
			return [self]
		}

		var result = [Range<Bound>]()
		if rangeToSubtract.lowerBound > lowerBound {
			result.append(lowerBound ..< rangeToSubtract.lowerBound)
		}
		if rangeToSubtract.upperBound < upperBound {
			result.append(rangeToSubtract.upperBound ..< upperBound)
		}

		return result
	}
}

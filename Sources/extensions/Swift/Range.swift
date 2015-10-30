public extension Range where Element.Distance: RandomizableIntegerType {

	public var randomIndex: Element? {
		let distance = startIndex.distanceTo(endIndex) - 1
		if distance == 0 {
			return nil
		}

		return startIndex.advancedBy(Element.Distance.random(start: 0, end: distance))
	}
}

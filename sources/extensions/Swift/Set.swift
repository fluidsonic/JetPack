public extension Set {

	public init(element: Element) {
		self.init()

		insert(element)
	}


	public mutating func filterInPlace(includeElement: (Element) -> Bool) {
		var excludes = [Element]()
		for element in self {
			if !includeElement(element) {
				excludes.append(element)
			}
		}

		subtractInPlace(excludes)
	}


	@warn_unused_result(mutable_variant="filterInPlace()")
	public func filterAsSet(includeElement: (Element) -> Bool) -> Set<Element> {
		var newSet = Set<Element>()
		for element in self {
			if includeElement(element) {
				newSet.insert(element)
			}
		}

		return newSet
	}
}

public extension Set {

	public init(element: Element) {
		self.init()

		insert(element)
	}


	@warn_unused_result(mutable_variant="filterInPlace")
	public func filterAsSet(@noescape includeElement: Element throws -> Bool) rethrows -> Set<Element> {
		var newSet = Set<Element>()
		for element in self where try includeElement(element) {
			newSet.insert(element)
		}

		return newSet
	}


	public mutating func filterInPlace(@noescape includeElement: Element throws -> Bool) rethrows {
		var excludes = [Element]()
		for element in self where !(try includeElement(element)) {
			excludes.append(element)
		}

		subtractInPlace(excludes)
	}
}

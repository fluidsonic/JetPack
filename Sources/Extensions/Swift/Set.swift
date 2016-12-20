public extension Set {

	public init(element: Element) {
		self.init()

		insert(element)
	}


	
	public func filterAsSet(includeElement: (Element) throws -> Bool) rethrows -> Set<Element> {
		var newSet = Set<Element>()
		for element in self where try includeElement(element) {
			newSet.insert(element)
		}

		return newSet
	}


	public mutating func filterInPlace(includeElement: (Element) throws -> Bool) rethrows {
		var excludes = [Element]()
		for element in self where !(try includeElement(element)) {
			excludes.append(element)
		}

		subtract(excludes)
	}


	
	public func intersects(_ set: Set<Element>) -> Bool {
		return contains { set.contains($0) }
	}


	
	public func toSet() -> Set<Iterator.Element> {
		return self
	}
}

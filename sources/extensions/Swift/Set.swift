public extension Set {

	public init(element: T) {
		self.init()

		insert(element)
	}


	public mutating func filterInPlace(includeElement: (T) -> Bool) {
		var excludes = [T]()
		for element in self {
			if !includeElement(element) {
				excludes.append(element)
			}
		}

		subtractInPlace(excludes)
	}


	@warn_unused_result(mutable_variant="filterInPlace()")
	public func filterAsSet(includeElement: (T) -> Bool) -> Set<T> {
		var newSet = Set<T>()
		for element in self {
			if includeElement(element) {
				newSet.insert(element)
			}
		}

		return newSet
	}
}

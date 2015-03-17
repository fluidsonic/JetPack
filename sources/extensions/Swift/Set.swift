extension Set {

	init(element: T) {
		self.init()

		insert(element)
	}


	mutating func filter(includeElement: (T) -> Bool) {
		var excludes = [T]()
		for element in self {
			if !includeElement(element) {
				excludes.append(element)
			}
		}

		self.subtractInPlace(excludes)
	}


	func filtered(includeElement: (T) -> Bool) -> Set<T> {
		var newSet = Set<T>()
		for element in self {
			if includeElement(element) {
				newSet.insert(element)
			}
		}

		return newSet
	}


	func mapped<U: Hashable>(transform: (T) -> U) -> Set<U> {
		var mappedSet = Set<U>()
		for element in self {
			mappedSet.insert(transform(element))
		}

		return mappedSet
	}
}

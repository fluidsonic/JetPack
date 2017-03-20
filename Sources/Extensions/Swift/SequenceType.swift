public extension Sequence {

	public func associated <Key: Hashable, Value>(elementSelector: (Iterator.Element) throws -> (Key, Value)) rethrows -> [Key : Value] {
		var dictionary = [Key : Value]()
		for element in self {
			let (key, value) = try elementSelector(element)
			dictionary[key] = value
		}

		return dictionary
	}

	
	public func associated <Key: Hashable> (by keySelector: (Iterator.Element) throws -> Key) rethrows -> [Key : Iterator.Element] {
		return try associated { (try keySelector($0), $0) }
	}


	public func countMatching(predicate: (Iterator.Element) throws -> Bool) rethrows -> Int {
		var count = 0
		for element in self where try predicate(element) {
			count += 1
		}

		return count
	}


	public func filterIsInstance <Type> (of type: Type.Type = Type.self) -> [Type] {
		var result = [Type]()
		for element in self {
			if let element = element as? Type {
				result.append(element)
			}
		}

		return result
	}


	public func firstMatching(predicate: (Iterator.Element) throws -> Bool) rethrows -> Iterator.Element? {
		for element in self where try predicate(element) {
			return element
		}

		return nil
	}

	
	public func joined(separator: String, lastSeparator: String, transform: (Iterator.Element) throws -> String) rethrows -> String {
		guard lastSeparator != separator else {
			return try joined(separator: separator, transform: transform)
		}

		var isFirstElement = true
		var joinedString = ""
		var previousElement: Iterator.Element?

		for element in self {
			if let previousElement = previousElement {
				if isFirstElement {
					isFirstElement = false
				}
				else {
					joinedString += separator
				}

				joinedString += try transform(previousElement)
			}

			previousElement = element
		}

		if let previousElement = previousElement {
			if !isFirstElement {
				joinedString += lastSeparator
			}

			joinedString += try transform(previousElement)
		}

		return joinedString
	}


	public func joined(separator: String, transform: (Iterator.Element) throws -> String) rethrows -> String {
		return try lazy.map(transform).joined(separator: separator)
	}


	public func mapNotNil<T>(transform: (Iterator.Element) throws -> T?) rethrows -> [T] {
		var result = [T]()
		for element in self {
			guard let mappedElement = try transform(element) else {
				continue
			}

			result.append(mappedElement)
		}

		return result
	}


	public func separate(isLeftElement: (Iterator.Element) throws -> Bool) rethrows -> ([Iterator.Element], [Iterator.Element]) {
		var left = Array<Iterator.Element>()
		var right = Array<Iterator.Element>()

		for element in self {
			if try isLeftElement(element) {
				left.append(element)
			}
			else {
				right.append(element)
			}
		}

		return (left, right)
	}


	public func sorted <SortKey: Comparable>(by sortKeySelector: (Iterator.Element) -> SortKey) -> [Iterator.Element] {
		return sorted { sortKeySelector($0) < sortKeySelector($1) }
	}


	// TODO we should probably rework this to return [ArraySlice<Iterator.Element>]
	public func split(byCount partitionSize: Int) -> [[Iterator.Element]] {
		precondition(partitionSize > 0, "partitionSize must be > 0")

		var partitions = Array<Array<Iterator.Element>>()
		var currentPartition = Array<Iterator.Element>()

		for element in self {
			if currentPartition.count >= partitionSize {
				partitions.append(currentPartition)
				currentPartition.removeAll(keepingCapacity: true)
			}

			currentPartition.append(element)
		}

		if !currentPartition.isEmpty {
			partitions.append(currentPartition)
		}

		return partitions
	}


	public func toArray() -> [Iterator.Element] {
		return Array<Iterator.Element>(self)
	}


	@available(*, deprecated: 1, renamed: "associated")
	public func toDictionary <Key: Hashable, Value>(transform: (Iterator.Element) throws -> (Key, Value)) rethrows -> [Key : Value] {
		return try associated(elementSelector: transform)
	}
}



public extension Sequence where Iterator.Element: AnyObject {

	public func containsIdentical(_ element: Iterator.Element) -> Bool {
		for existingElement in self where existingElement === element {
			return true
		}

		return false
	}
}



public extension Sequence where Iterator.Element: Hashable {

	public func toSet() -> Set<Iterator.Element> {
		return Set(self)
	}
}



public extension Sequence where Iterator.Element == String {

	public func joined(separator: String, lastSeparator: String) -> String {
		return joined(separator: separator, lastSeparator: lastSeparator, transform: identity)
	}
}



public extension Sequence where Iterator.Element: _Optional {

	public func filterNonNil() -> [Iterator.Element.Wrapped] {
		var result = Array<Iterator.Element.Wrapped>()
		for element in self {
			guard let element = element.value else {
				continue
			}

			result.append(element)
		}

		return result
	}
}

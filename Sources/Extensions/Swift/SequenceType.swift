public extension Sequence {

	public func associated <Key, Value>(elementSelector: (Element) throws -> (Key, Value)) rethrows -> [Key : Value] {
		var dictionary = [Key : Value]()
		for element in self {
			let (key, value) = try elementSelector(element)
			dictionary[key] = value
		}

		return dictionary
	}


	@available(*, unavailable, renamed: "associatedBy")
	public func associated <Key> (by keySelector: (Element) throws -> Key) rethrows -> [Key : Element] {
		return try associated { (try keySelector($0), $0) }
	}


	public func associatedBy <Key> (_ keySelector: (Element) throws -> Key) rethrows -> [Key : Element] {
		return try associated { (try keySelector($0), $0) }
	}


	public func countMatching(predicate: (Element) throws -> Bool) rethrows -> Int {
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


	public func firstMatching(predicate: (Element) throws -> Bool) rethrows -> Element? {
		for element in self where try predicate(element) {
			return element
		}

		return nil
	}

	
	public func joined(separator: String, lastSeparator: String, transform: (Element) throws -> String) rethrows -> String {
		guard lastSeparator != separator else {
			return try joined(separator: separator, transform: transform)
		}

		var isFirstElement = true
		var joinedString = ""
		var previousElement: Element?

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


	public func joined(separator: String, transform: (Element) throws -> String) rethrows -> String {
		return try lazy.map(transform).joined(separator: separator)
	}


	public func mapNotNil<T>(transform: (Element) throws -> T?) rethrows -> [T] {
		var result = [T]()
		for element in self {
			guard let mappedElement = try transform(element) else {
				continue
			}

			result.append(mappedElement)
		}

		return result
	}


	public func separate(isLeftElement: (Element) throws -> Bool) rethrows -> ([Element], [Element]) {
		var left = Array<Element>()
		var right = Array<Element>()

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


	public func sorted <SortKey: Comparable>(by sortKeySelector: (Element) -> SortKey) -> [Element] {
		return sorted { sortKeySelector($0) < sortKeySelector($1) }
	}


	// TODO we should probably rework this to return [ArraySlice<Element>]
	public func split(byCount partitionSize: Int) -> [[Element]] {
		precondition(partitionSize > 0, "partitionSize must be > 0")

		var partitions = Array<Array<Element>>()
		var currentPartition = Array<Element>()

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


	public func toArray() -> [Element] {
		return Array<Element>(self)
	}


	@available(*, deprecated: 1, renamed: "associated")
	public func toDictionary <Key, Value>(transform: (Element) throws -> (Key, Value)) rethrows -> [Key : Value] {
		return try associated(elementSelector: transform)
	}
}



public extension Sequence where Element: AnyObject {

	public func containsIdentical(_ element: Element) -> Bool {
		for existingElement in self where existingElement === element {
			return true
		}

		return false
	}
}



public extension Sequence where Element: Hashable {

	public func toSet() -> Set<Element> {
		return Set(self)
	}
}



public extension Sequence where Element == String {

	public func joined(separator: String, lastSeparator: String) -> String {
		return joined(separator: separator, lastSeparator: lastSeparator, transform: identity)
	}
}



public extension Sequence where Element: _Optional {

	public func filterNonNil() -> [Element.Wrapped] {
		var result = Array<Element.Wrapped>()
		for element in self {
			guard let element = element.value else {
				continue
			}

			result.append(element)
		}

		return result
	}
}

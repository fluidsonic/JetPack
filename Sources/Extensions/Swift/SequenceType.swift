public extension SequenceType {

	@warn_unused_result
	public func toArray() -> [Generator.Element] {
		return Array<Generator.Element>(self)
	}


	@warn_unused_result
	public func countMatching(@noescape predicate: Generator.Element throws -> Bool) rethrows -> Int {
		var count = 0
		for element in self where try predicate(element) {
			count += 1
		}

		return count
	}


	@warn_unused_result
	public func firstMatching(@noescape predicate: Generator.Element throws -> Bool) rethrows -> Generator.Element? {
		for element in self where try predicate(element) {
			return element
		}

		return nil
	}


	@warn_unused_result
	public func joinWithSeparator(separator: String, lastSeparator: String, @noescape transform: Generator.Element throws -> String) rethrows -> String {
		guard lastSeparator != separator else {
			return try joinWithSeparator(separator, transform: transform)
		}

		var isFirstElement = true
		var joinedString = ""
		var previousElement: Generator.Element?

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


	@warn_unused_result
	public func joinWithSeparator(separator: String, @noescape transform: Generator.Element throws -> String) rethrows -> String {
		return try lazy.map(transform).joinWithSeparator(separator)
	}


	@warn_unused_result
	public func separate(@noescape isLeftElement: Generator.Element throws -> Bool) rethrows -> ([Generator.Element], [Generator.Element]) {
		var left = Array<Generator.Element>()
		var right = Array<Generator.Element>()

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


	@warn_unused_result
	public func toDictionary <Key: Hashable, Value>(@noescape transform: Generator.Element throws -> (Key, Value)) rethrows -> [Key : Value] {
		var dictionary = [Key : Value]()
		for element in self {
			let (key, value) = try transform(element)
			dictionary[key] = value
		}

		return dictionary
	}
}



public extension SequenceType where Generator.Element: AnyObject {

	@warn_unused_result
	public func containsIdentical(element: Generator.Element) -> Bool {
		for existingElement in self where existingElement === element {
			return true
		}

		return false
	}
}



public extension SequenceType where Generator.Element: Hashable {

	@warn_unused_result
	public func toSet() -> Set<Generator.Element> {
		return Set(self)
	}
}



public extension SequenceType where Generator.Element == String {

	@warn_unused_result
	public func joinWithSeparator(separator: String, lastSeparator: String) -> String {
		return joinWithSeparator(separator, lastSeparator: lastSeparator, transform: identity)
	}
}



public extension SequenceType where Generator.Element: _Optional {

	@warn_unused_result
	public func filterNonNil() -> [Generator.Element.Wrapped] {
		var result = Array<Generator.Element.Wrapped>()
		for element in self {
			guard let element = element.value else {
				continue
			}

			result.append(element)
		}

		return result
	}
}

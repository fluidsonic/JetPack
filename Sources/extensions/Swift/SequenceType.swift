public extension SequenceType {

	@available(*, deprecated=1, renamed="countMatching")
	@warn_unused_result
	public func count(@noescape predicate: Generator.Element throws -> Bool) rethrows -> Int {
		return try countMatching(predicate)
	}


	@warn_unused_result
	public func countMatching(@noescape predicate: Generator.Element throws -> Bool) rethrows -> Int {
		var count = 0
		for element in self where try predicate(element) {
			count += 1
		}

		return count
	}


	@available(*, deprecated=1, renamed="firstMatching")
	@warn_unused_result
	public func first(@noescape predicate: Generator.Element throws -> Bool) rethrows -> Generator.Element? {
		return try firstMatching(predicate)
	}


	@warn_unused_result
	public func firstMatching(@noescape predicate: Generator.Element throws -> Bool) rethrows -> Generator.Element? {
		for element in self where try predicate(element) {
			return element
		}

		return nil
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

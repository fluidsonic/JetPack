public extension SequenceType {

	@warn_unused_result
	public func count(@noescape predicate: Generator.Element throws -> Bool) rethrows -> Int {
		var count = 0
		for element in self where try predicate(element) {
			++count
		}

		return count
	}


	@warn_unused_result
	public func first(@noescape predicate: Generator.Element throws -> Bool) rethrows -> Generator.Element? {
		for element in self {
			if try predicate(element) {
				return element
			}
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

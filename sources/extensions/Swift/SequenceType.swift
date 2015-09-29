public extension SequenceType {

	public func count(@noescape predicate: Generator.Element throws -> Bool) rethrows -> Int {
		var count = 0
		for element in self where try predicate(element) {
			++count
		}

		return count
	}
}


public extension SequenceType where Self.Generator.Element: AnyObject {

	public func containsIdentical(element: Generator.Element) -> Bool {
		for existingElement in self where existingElement === element {
			return true
		}

		return false
	}
}

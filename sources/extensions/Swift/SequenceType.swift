public extension SequenceType where Self.Generator.Element: AnyObject {

	public func containsIdentical(element: Generator.Element) -> Bool {
		for existingElement in self where existingElement === element {
			return true
		}

		return false
	}
}

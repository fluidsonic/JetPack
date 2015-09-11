public extension CollectionType {

	@warn_unused_result
	public func lastIndexOf(@noescape predicate: Generator.Element throws -> Bool) rethrows -> Index? {
		for index in (startIndex ..< endIndex).reverse() {
			if try predicate(self[index]) {
				return index
			}
		}

		return nil
	}
}


public extension CollectionType where Self.Generator.Element: Equatable {

	@warn_unused_result
	public func indexOf(element: Generator.Element) -> Index? {
		for index in (startIndex ..< endIndex).reverse() {
			if self[index] == element {
				return index
			}
		}

		return nil
	}
}

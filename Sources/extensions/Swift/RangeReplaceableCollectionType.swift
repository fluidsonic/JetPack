public extension RangeReplaceableCollectionType {

	public mutating func removeFirst(@noescape predicate: Generator.Element throws -> Bool) rethrows -> (Index, Generator.Element)? {
		guard let index = try indexOf(predicate) else {
			return nil
		}

		return (index, removeAtIndex(index))
	}
}


public extension RangeReplaceableCollectionType where Generator.Element: AnyObject {

	public mutating func removeFirstIdentical(element: Generator.Element) -> Index? {
		guard let index = indexOfIdentical(element) else {
			return nil
		}

		removeAtIndex(index)
		return index
	}
}


public extension RangeReplaceableCollectionType where Generator.Element: Equatable {

	public mutating func removeFirst(element: Generator.Element) -> (Index, Generator.Element)? {
		guard let index = indexOf(element) else {
			return nil
		}

		return (index, removeAtIndex(index))
	}
}

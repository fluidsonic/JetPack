public extension RangeReplaceableCollection {

	public mutating func removeFirstMatching(predicate: (Iterator.Element) throws -> Bool) rethrows -> (Index, Iterator.Element)? {
		guard let index = try index(where: predicate) else {
			return nil
		}

		return (index, remove(at: index))
	}
}


public extension RangeReplaceableCollection where Indices.Iterator.Element == Index, Iterator.Element: AnyObject {

	public mutating func removeFirstIdentical(_ element: Iterator.Element) -> Index? {
		guard let index = indexOfIdentical(element) else {
			return nil
		}

		remove(at: index)
		return index
	}
}


public extension RangeReplaceableCollection where Iterator.Element: Equatable {

	public mutating func removeFirstEqual(_ element: Iterator.Element) -> (Index, Iterator.Element)? {
		guard let index = index(of: element) else {
			return nil
		}

		return (index, remove(at: index))
	}
}

public extension Collection {

	public var nonEmpty: Self? {
		return isEmpty ? nil : self
	}
}


public extension Collection where Indices.Iterator.Element == Index {

	public func lastIndexOf(predicate: (Iterator.Element) throws -> Bool) rethrows -> Index? {
		for index in indices.reversed() where try predicate(self[index]) {
			return index
		}

		return nil
	}

	public subscript(safe index: Index) -> Iterator.Element? {
		return indices.contains(index) ? self[index] : nil
	}
}


public extension Collection where Indices.Iterator.Element == Index, Iterator.Element: AnyObject {

	public func indexOfIdentical(_ element: Iterator.Element) -> Index? {
		for index in indices where self[index] === element {
			return index
		}

		return nil
	}
}


public extension Collection where Indices.Iterator.Element == Index, Iterator.Element: Equatable {

	public func lastIndexOf(_ element: Iterator.Element) -> Index? {
		for index in indices.reversed() where self[index] == element {
			return index
		}

		return nil
	}
}

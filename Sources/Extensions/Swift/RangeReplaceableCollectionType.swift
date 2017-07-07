public extension RangeReplaceableCollection {

	@discardableResult
	public mutating func removeFirstMatching(predicate: (Element) throws -> Bool) rethrows -> (Index, Element)? {
		guard let index = try index(where: predicate) else {
			return nil
		}

		return (index, remove(at: index))
	}
}


public extension RangeReplaceableCollection where Element: AnyObject {

	@discardableResult
	public mutating func removeFirstIdentical(_ element: Element) -> Index? {
		guard let index = indexOfIdentical(element) else {
			return nil
		}

		remove(at: index)
		return index
	}
}


public extension RangeReplaceableCollection where Element: Equatable {

	@discardableResult
	public mutating func removeFirstEqual(_ element: Element) -> (Index, Element)? {
		guard let index = index(of: element) else {
			return nil
		}

		return (index, remove(at: index))
	}
}

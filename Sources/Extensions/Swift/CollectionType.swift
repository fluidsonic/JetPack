public extension CollectionType {

	@warn_unused_result
	public func lastIndexOf(@noescape predicate: Generator.Element throws -> Bool) rethrows -> Index? {
		for index in (startIndex ..< endIndex).reverse() where try predicate(self[index]) {
			return index
		}

		return nil
	}


	public subscript(safe index: Index) -> Generator.Element? {
		return indices.contains(index) ? self[index] : nil
	}
}


public extension CollectionType where Generator.Element: AnyObject {

	@warn_unused_result
	public func indexOfIdentical(element: Generator.Element) -> Index? {
		for index in startIndex ..< endIndex where self[index] === element {
			return index
		}

		return nil
	}
}


public extension CollectionType where Generator.Element: Equatable {

	@warn_unused_result
	public func lastIndexOf(element: Generator.Element) -> Index? {
		for index in (startIndex ..< endIndex).reverse() where self[index] == element {
			return index
		}

		return nil
	}
}


public extension CollectionType where Index.Distance: RandomizableIntegerType {

	public var randomElement: Generator.Element? {
		guard let index = (startIndex ..< endIndex).randomIndex else {
			return nil
		}

		return self[index]
	}
}

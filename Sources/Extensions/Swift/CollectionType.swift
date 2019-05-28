public extension Collection {

	func lastIndexOf(predicate: (Element) throws -> Bool) rethrows -> Index? {
		for index in indices.reversed() where try predicate(self[index]) {
			return index
		}

		return nil
	}


	var nonEmpty: Self? {
		return isEmpty ? nil : self
	}


	subscript(safe index: Index) -> Element? {
		return indices.contains(index) ? self[index] : nil
	}
}


public extension Collection where Element: AnyObject {

	func indexOfIdentical(_ element: Element) -> Index? {
		for index in indices where self[index] === element {
			return index
		}

		return nil
	}
}


public extension Collection where Element: Equatable {

	func lastIndexOf(_ element: Element) -> Index? {
		for index in indices.reversed() where self[index] == element {
			return index
		}

		return nil
	}
}

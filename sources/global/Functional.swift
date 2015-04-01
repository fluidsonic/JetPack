public func any<S : SequenceType>(source: S, includeElement: (S.Generator.Element) -> Bool) -> Bool {
	for element in source {
		if includeElement(element) {
			return true
		}
	}

	return false
}


internal func arc4random<T: IntegerLiteralConvertible>(type: T.Type) -> T {
	var random: T = 0
	arc4random_buf(&random, sizeof(T))
	return random
}


public func findIdentical<C: CollectionType where C.Generator.Element: AnyObject>(collection: C, element: C.Generator.Element) -> C.Index? {
	for index in collection.startIndex ..< collection.endIndex {
		if collection[index] === element {
			return index
		}
	}

	return nil
}


public func findLast<C: CollectionType where C.Generator.Element: Equatable, C.Index: BidirectionalIndexType>(collection: C, element: C.Generator.Element) -> C.Index? {
	for index in reverse(collection.startIndex ..< collection.endIndex) {
		if collection[index] == element {
			return index
		}
	}

	return nil
}


public func first<S : SequenceType>(source: S, includeElement: (S.Generator.Element) -> Bool) -> S.Generator.Element? {
	for element in source {
		if includeElement(element) {
			return element
		}
	}

	return nil
}

public func not<T>(source: T -> Bool) -> T -> Bool {
	return { !source($0) }
}


public func not<T>(source: Bool) -> Bool {
	return !source
}


public func optionalMax <T: Comparable>(elements: T? ...) -> T? {
	var maximumElement: T?

	for element in elements {
		if let element = element {
			if let existingMaximumElement = maximumElement {
				if element > existingMaximumElement {
					maximumElement = element
				}
			}
			else {
				maximumElement = element
			}
		}
	}

	return maximumElement
}


public func optionalMin <T: Comparable>(elements: T? ...) -> T? {
	var minimumElement: T?

	for element in elements {
		if let element = element {
			if let existingMinimumElement = minimumElement {
				if element < existingMinimumElement {
					minimumElement = element
				}
			}
			else {
				minimumElement = element
			}
		}
	}

	return minimumElement
}


public func removeFirst<C : RangeReplaceableCollectionType where C.Generator.Element : Equatable>(inout collection: C, element: C.Generator.Element) -> C.Index? {
	let index = find(collection, element)
	if let index = index {
		collection.removeAtIndex(index)
	}

	return index
}


public func removeFirstIdentical<C : RangeReplaceableCollectionType where C.Generator.Element : AnyObject>(inout collection: C, element: C.Generator.Element) -> C.Index? {
	let index = findIdentical(collection, element)
	if let index = index {
		collection.removeAtIndex(index)
	}

	return index
}


public func separate<E, S : SequenceType where S.Generator.Element == E>(source: S, isLeftElement: (E) -> Bool) -> ([E], [E]) {
	var left = [E]()
	var right = [E]()

	for element in source {
		if isLeftElement(element) {
			left.append(element)
		}
		else {
			right.append(element)
		}
	}

	return (left, right)
}

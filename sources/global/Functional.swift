func any<S : SequenceType>(source: S, includeElement: (S.Generator.Element) -> Bool) -> Bool {
	for element in source {
		if includeElement(element) {
			return true
		}
	}

	return false
}


func findIdentical<C: CollectionType where C.Generator.Element: AnyObject>(collection: C, element: C.Generator.Element) -> C.Index? {
	for index in collection.startIndex ..< collection.endIndex {
		if collection[index] === element {
			return index
		}
	}

	return nil
}


func findLast<C: CollectionType where C.Generator.Element: Equatable, C.Index: BidirectionalIndexType>(collection: C, element: C.Generator.Element) -> C.Index? {
	for index in reverse(collection.startIndex ..< collection.endIndex) {
		if collection[index] == element {
			return index
		}
	}

	return nil
}


func first<S : SequenceType>(source: S, matches: (S.Generator.Element) -> Bool) -> S.Generator.Element? {
	for element in source {
		if matches(element) {
			return element
		}
	}

	return nil
}


func not<T>(source: T -> Bool) -> T -> Bool {
	return { !source($0) }
}


func not<T>(source: Bool) -> Bool {
	return !source
}


func removeFirst<C : RangeReplaceableCollectionType where C.Generator.Element : Equatable>(inout collection: C, element: C.Generator.Element) -> C.Index? {
	let index = find(collection, element)
	if let index = index {
		collection.removeAtIndex(index)
	}

	return index
}


func removeFirstIdentical<C : RangeReplaceableCollectionType where C.Generator.Element : AnyObject>(inout collection: C, element: C.Generator.Element) -> C.Index? {
	let index = findIdentical(collection, element)
	if let index = index {
		collection.removeAtIndex(index)
	}

	return index
}


func separate<E, S : SequenceType where S.Generator.Element == E>(source: S, isLeftElement: (E) -> Bool) -> ([E], [E]) {
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

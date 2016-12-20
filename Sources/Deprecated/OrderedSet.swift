import Foundation


public struct OrderedSet<T: Hashable> {

	public typealias Element = T

	fileprivate var elements: Set<T>
	fileprivate var orderedElements = [T]()


	public init() {
		self.init(minimumCapacity: 2)
	}


	public init(minimumCapacity: Int) {
		elements = Set(minimumCapacity: minimumCapacity)
		orderedElements.reserveCapacity(minimumCapacity)
	}


	public init(element: T) {
		self.init(minimumCapacity: 1)

		add(element)
	}


	public init(elements: T...) {
		self.init(minimumCapacity: elements.count)

		union(elements)
	}


	public init<S: Sequence>(_ sequence: S) where S.Iterator.Element == T {
		self.init()

		union(sequence)
	}


	public init(_ orderedSet: OrderedSet<T>) {
		elements = orderedSet.elements
		orderedElements = orderedSet.orderedElements
	}


	public mutating func add(_ element: T) -> Bool {
		if elements.contains(element) {
			return false
		}

		elements.insert(element)
		orderedElements.append(element)

		return true
	}


	public var any: T? {
		return orderedElements.first
	}


	public func contains(_ element: T) -> Bool {
		return elements.contains(element)
	}


	public func contains(_ matches: (T) -> Bool) -> Bool {
		for element in orderedElements {
			if matches(element) {
				return true
			}
		}

		return false
	}


	public var count: Int {
		return elements.count
	}


	
	public func filterAsOrderedSet(includeElement: (T) throws -> Bool) rethrows -> OrderedSet<T> {
		var filteredElements = OrderedSet<T>()
		for element in orderedElements where try includeElement(element) {
			filteredElements.add(element)
		}

		return filteredElements
	}


	public mutating func filterInPlace(includeElement: (T) throws -> Bool) rethrows {
		var excludes = [T]()
		for element in elements where !(try includeElement(element)) {
			excludes.append(element)
		}

		minus(excludes)
	}


	public var first: T? {
		return orderedElements.first
	}


	public func indexOf(_ element: T) -> Int? {
		if elements.contains(element) {
			var index = 0
			for existingElement in orderedElements {
				if existingElement == element {
					return index
				}

				index += 1
			}
		}

		return nil
	}


	public mutating func intersect(_ set: OrderedSet<T>) {
		filterInPlace { set.contains($0) }
	}


	public func intersected(_ set: OrderedSet<T>) -> OrderedSet<T> {
		return filterAsOrderedSet { set.contains($0) }
	}


	public func intersects(_ set: OrderedSet<T>) -> Bool {
		return contains { set.contains($0) }
	}


	public var isEmpty: Bool {
		return elements.isEmpty
	}


	public func isSubsetOf(_ set: OrderedSet<T>) -> Bool {
		return elements.isSubset(of: set)
	}


	public var last: T? {
		return orderedElements.last
	}


	
	public func mapAsOrderedSet<U: Hashable>(transform: (T) throws -> U) rethrows -> OrderedSet<U> {
		var newSet = OrderedSet<U>(minimumCapacity: count)
		for element in orderedElements {
			newSet.add(try transform(element))
		}

		return newSet
	}


	public func member(_ element: T) -> T? {
		if let index = elements.index(of: element) {
			return elements[index]
		}

		return nil
	}


	public mutating func minus<S: Sequence>(_ sequence: S) where S.Iterator.Element == T {
		for element in sequence {
			remove(element)
		}
	}


	public func minused<S: Sequence>(_ sequence: S) -> OrderedSet<T> where S.Iterator.Element == T {
		var copy = self
		copy.minus(sequence)

		return copy
	}


	public mutating func move(fromIndex: Int, toIndex: Int) {
		precondition(fromIndex >= startIndex && fromIndex < endIndex, "fromIndex outside range \(startIndex) ..< \(endIndex)")
		precondition(toIndex >= startIndex && toIndex < endIndex, "toIndex outside range \(startIndex) ..< \(endIndex)")

		if fromIndex == toIndex {
			return
		}

		orderedElements.insert(orderedElements.remove(at: fromIndex), at: toIndex)
	}


	public mutating func removeAtIndex(_ index: Int) -> T {
		let element = orderedElements[index]
		orderedElements.remove(at: index)

		return elements.remove(element)!
	}


	public mutating func remove(_ element: T) -> T? {
		var removedElementToReturn: T?
		if let index = indexOf(element) {
			if let removedElement = elements.remove(element) {
				orderedElements.remove(at: index)
				removedElementToReturn = removedElement
			}
		}

		return removedElementToReturn
	}


	public mutating func removeAll() {
		removeAll(keepCapacity: false)
	}


	public mutating func removeAll(keepCapacity: Bool) {
		elements.removeAll(keepingCapacity: keepCapacity)
		orderedElements.removeAll(keepingCapacity: keepCapacity)
	}


	public mutating func replace(_ element: T) -> T? {
		var replacedElementToReturn: T?
		if let index = indexOf(element) {
			if let replacedElement = elements.remove(element) {
				elements.insert(element)
				orderedElements[index] = element
				replacedElementToReturn = replacedElement
			}
		}

		return replacedElementToReturn
	}


	public mutating func union<S: Sequence>(_ sequence: S) where S.Iterator.Element == T {
		for element in sequence {
			add(element)
		}
	}


	public func unioned<S: Sequence>(_ sequence: S) -> OrderedSet<T> where S.Iterator.Element == T {
		var copy = self
		copy.union(sequence)

		return copy
	}


	public subscript(bounds: Range<Int>) -> OrderedSet<T> {
		var set = OrderedSet<T>()
		for element in orderedElements[bounds] {
			set.add(element)
		}

		return set
	}
}


extension OrderedSet: ExpressibleByArrayLiteral {

	public init(arrayLiteral elements: T...) {
		self.init(elements)
	}
}


extension OrderedSet: Collection {

	public var endIndex: Int {
		return orderedElements.endIndex
	}


	public func index(after index: Int) -> Int {
		return orderedElements.index(after: index)
	}


	public var startIndex: Int {
		return orderedElements.startIndex
	}


	public subscript(index: Int) -> T {
		return orderedElements[index]
	}
}


extension OrderedSet: CustomDebugStringConvertible {

	public var debugDescription: String {
		return description
	}
}


extension OrderedSet: CustomStringConvertible {

	public var description: String {
		var description = "OrderedSet["

		var isFirstElement = true
		for element in orderedElements {
			if isFirstElement {
				isFirstElement = false
			}
			else {
				description += ", "
			}

			description += "\(element)"
		}

		description += "]"

		return description
	}
}


extension OrderedSet: Equatable {}


extension OrderedSet: Hashable {

	public var hashValue: Int {
		var hashValue = 1
		for element in orderedElements {
			hashValue = (hashValue &* 31) &+ element.hashValue
		}

		return hashValue
	}
}


extension OrderedSet: Sequence {

	public typealias Iterator = IndexingIterator<[T]>


	public func makeIterator() -> Iterator {
		return orderedElements.makeIterator()
	}
}


public func ==<T> (a: OrderedSet<T>, b: OrderedSet<T>) -> Bool {
	if a.count != b.count {
		return false
	}

	for index in 0 ..< a.count {
		if a[index] != b[index] {
			return false
		}
	}
	
	return true
}

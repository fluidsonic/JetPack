import Foundation


public struct OrderedSet<T: Hashable> {

	public typealias Element = T

	private var elements: Set<T>
	private var orderedElements = [T]()


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


	public init<S: SequenceType where S.Generator.Element == T>(_ sequence: S) {
		self.init()

		union(sequence)
	}


	public init(_ orderedSet: OrderedSet<T>) {
		elements = orderedSet.elements
		orderedElements = orderedSet.orderedElements
	}


	public mutating func add(element: T) -> Bool {
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


	public func contains(element: T) -> Bool {
		return elements.contains(element)
	}


	public func contains(matches: (T) -> Bool) -> Bool {
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


	@warn_unused_result
	public func filterAsOrderedSet(@noescape includeElement: T throws -> Bool) rethrows -> OrderedSet<T> {
		var filteredElements = OrderedSet<T>()
		for element in orderedElements where try includeElement(element) {
			filteredElements.add(element)
		}

		return filteredElements
	}


	public mutating func filterInPlace(@noescape includeElement: T throws -> Bool) rethrows {
		var excludes = [T]()
		for element in elements where !(try includeElement(element)) {
			excludes.append(element)
		}

		minus(excludes)
	}


	public var first: T? {
		return orderedElements.first
	}


	public func indexOf(element: T) -> Int? {
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


	public mutating func intersect(set: OrderedSet<T>) {
		filterInPlace { set.contains($0) }
	}


	public func intersected(set: OrderedSet<T>) -> OrderedSet<T> {
		return filterAsOrderedSet { set.contains($0) }
	}


	public func intersects(set: OrderedSet<T>) -> Bool {
		return contains { set.contains($0) }
	}


	public var isEmpty: Bool {
		return elements.isEmpty
	}


	public func isSubsetOf(set: OrderedSet<T>) -> Bool {
		return elements.isSubsetOf(set)
	}


	public var last: T? {
		return orderedElements.last
	}


	@warn_unused_result
	public func mapAsOrderedSet<U: Hashable>(@noescape transform: T throws -> U) rethrows -> OrderedSet<U> {
		var newSet = OrderedSet<U>(minimumCapacity: count)
		for element in orderedElements {
			newSet.add(try transform(element))
		}

		return newSet
	}


	public func member(element: T) -> T? {
		if let index = elements.indexOf(element) {
			return elements[index]
		}

		return nil
	}


	public mutating func minus<S: SequenceType where S.Generator.Element == T>(sequence: S) {
		for element in sequence {
			remove(element)
		}
	}


	public func minused<S: SequenceType where S.Generator.Element == T>(sequence: S) -> OrderedSet<T> {
		var copy = self
		copy.minus(sequence)

		return copy
	}


	public mutating func move(fromIndex fromIndex: Int, toIndex: Int) {
		precondition(fromIndex >= startIndex && fromIndex < endIndex, "fromIndex outside range \(startIndex) ..< \(endIndex)")
		precondition(toIndex >= startIndex && toIndex < endIndex, "toIndex outside range \(startIndex) ..< \(endIndex)")

		if fromIndex == toIndex {
			return
		}

		orderedElements.insert(orderedElements.removeAtIndex(fromIndex), atIndex: toIndex)
	}


	public mutating func removeAtIndex(index: Int) -> T {
		let element = orderedElements[index]
		orderedElements.removeAtIndex(index)

		return elements.remove(element)!
	}


	public mutating func remove(element: T) -> T? {
		var removedElementToReturn: T?
		if let index = indexOf(element) {
			if let removedElement = elements.remove(element) {
				orderedElements.removeAtIndex(index)
				removedElementToReturn = removedElement
			}
		}

		return removedElementToReturn
	}


	public mutating func removeAll() {
		removeAll(keepCapacity: false)
	}


	public mutating func removeAll(keepCapacity keepCapacity: Bool) {
		elements.removeAll(keepCapacity: keepCapacity)
		orderedElements.removeAll(keepCapacity: keepCapacity)
	}


	public mutating func replace(element: T) -> T? {
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


	public mutating func union<S: SequenceType where S.Generator.Element == T>(sequence: S) {
		for element in sequence {
			add(element)
		}
	}


	public func unioned<S: SequenceType where S.Generator.Element == T>(sequence: S) -> OrderedSet<T> {
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


extension OrderedSet: ArrayLiteralConvertible {

	public init(arrayLiteral elements: T...) {
		self.init(elements)
	}
}


extension OrderedSet: CollectionType {

	public var endIndex: Int {
		return orderedElements.endIndex
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


extension OrderedSet: SequenceType {

	public typealias Generator = IndexingGenerator<[T]>


	public func generate() -> Generator {
		return orderedElements.generate()
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

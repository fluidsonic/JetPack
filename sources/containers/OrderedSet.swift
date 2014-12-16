import Foundation


public struct OrderedSet<T: Hashable>: MutableSetType {

	typealias Element = T

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


	public init<S: SequenceType where S.Generator.Element == T>(sequence: S) {
		self.init()

		union(elements)
	}


	public init(_ orderedSet: OrderedSet<T>) {
		elements = orderedSet.elements
		orderedElements = orderedSet.orderedElements
	}


	public mutating func add(element: T) -> Bool {
		if !elements.add(element) {
			return false
		}

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
		return elements.contains(matches)
	}


	public var count: Int {
		return elements.count
	}


	public mutating func filter(includeElement: (T) -> Bool) {
		var excludes = [T]()
		for element in elements {
			if !includeElement(element) {
				excludes.append(element)
			}
		}

		minus(excludes)
	}


	public func filtered(includeElement: (T) -> Bool) -> OrderedSet<T> {
		return OrderedSet(sequence: elements.filtered(includeElement))
	}


	public func indexOf(element: T) -> Int? {
		if elements.contains(element) {
			var index = 0
			for existingElement in orderedElements {
				if existingElement == element {
					return index
				}

				++index
			}
		}

		return nil
	}


	public mutating func intersect<S : SetType where S.Element == T>(set: S) {
		filter { set.contains($0) }
	}


	public func intersected<S : SetType where S.Element == T>(set: S) -> OrderedSet<T> {
		return filtered { set.contains($0) }
	}


	public func intersects<S : SetType where S.Element == T>(set: S) -> Bool {
		return contains { set.contains($0) }
	}


	public var isEmpty: Bool {
		return elements.isEmpty
	}


	public func isSubsetOf<S: SetType where S.Element == T>(set: S) -> Bool {
		return elements.isSubsetOf(set)
	}


	public func mapped<U: Hashable>(transform: (T) -> U) -> OrderedSet<U> {
		var newSet = OrderedSet<U>(minimumCapacity: count)
		for element in orderedElements {
			newSet.add(transform(element))
		}

		return newSet
	}


	public func member(element: T) -> T? {
		return elements.member(element)
	}


	public mutating func minus<S: SequenceType where S.Generator.Element == T>(sequence: S) {
		for element in SequenceOf<T>(sequence) {
			remove(element)
		}
	}


	public func minused<S: SequenceType where S.Generator.Element == T>(sequence: S) -> OrderedSet<T> {
		var copy = self
		copy.minus(sequence)

		return copy
	}


	public mutating func move(#fromIndex: Int, toIndex: Int) {
		precondition(fromIndex >= startIndex && fromIndex < endIndex, "fromIndex outside range \(startIndex) ..< \(endIndex)")
		precondition(toIndex >= startIndex && toIndex < endIndex, "toIndex outside range \(startIndex) ..< \(endIndex)")

		if fromIndex == toIndex {
			return
		}

		orderedElements.insert(orderedElements.removeAtIndex(fromIndex), atIndex: toIndex)
	}


	public mutating func union<S: SequenceType where S.Generator.Element == T>(sequence: S) {
		for element in SequenceOf<T>(sequence) {
			add(element)
		}
	}


	public func unioned<S: SequenceType where S.Generator.Element == T>(sequence: S) -> OrderedSet<T> {
		var copy = self
		copy.union(sequence)

		return copy
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


	public mutating func removeAll(#keepCapacity: Bool) {
		elements.removeAll(keepCapacity: keepCapacity)
		orderedElements.removeAll(keepCapacity: keepCapacity)
	}


	public mutating func replace(element: T) -> T? {
		var replacedElementToReturn: T?
		if let index = indexOf(element) {
			if let replacedElement = elements.replace(element) {
				orderedElements[index] = element
				replacedElementToReturn = replacedElement
			}
		}

		return replacedElementToReturn
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
		self.init(sequence: elements)
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


extension OrderedSet: DebugPrintable {

	public var debugDescription: String {
		return description
	}
}


extension OrderedSet: Printable {

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


extension OrderedSet: SequenceType {

	typealias Generator = IndexingGenerator<[T]>


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

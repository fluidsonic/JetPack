import Foundation


// TODO if we continue to support this, then conform to SetAlgebra

public struct OrderedSet<Element: Hashable> {

	fileprivate var elements: Set<Element>
	fileprivate var orderedElements = [Element]()


	public init() {
		self.init(minimumCapacity: 2)
	}


	public init(minimumCapacity: Int) {
		elements = Set(minimumCapacity: minimumCapacity)
		orderedElements.reserveCapacity(minimumCapacity)
	}


	public init(element: Element) {
		self.init(minimumCapacity: 1)

		add(element)
	}


	public init(elements: Element...) {
		self.init(minimumCapacity: elements.count)

		formUnion(elements)
	}


	public init<Source: Sequence>(_ sequence: Source) where Source.Iterator.Element == Element {
		self.init()

		formUnion(sequence)
	}


	public init(_ orderedSet: OrderedSet<Element>) {
		elements = orderedSet.elements
		orderedElements = orderedSet.orderedElements
	}


	@discardableResult
	public mutating func add(_ newMember: Element) -> (inserted: Bool, memberAfterInsert: Element) {
		let (inserted, memberAfterInsert) = elements.insert(newMember)
		guard inserted else {
			return (false, memberAfterInsert)
		}

		orderedElements.append(newMember)

		return (true, memberAfterInsert)
	}


	public var any: Element? {
		return orderedElements.first
	}


	public func contains(_ member: Element) -> Bool {
		return elements.contains(member)
	}


	public func contains(where predicate: (Element) throws -> Bool) rethrows -> Bool {
		for element in orderedElements where try predicate(element) {
			return true
		}

		return false
	}


	public var count: Int {
		return elements.count
	}

	
	public func filterAsOrderedSet(_ isIncluded: (Element) throws -> Bool) rethrows -> OrderedSet<Element> {
		var filteredElements = OrderedSet<Element>()
		for element in orderedElements where try isIncluded(element) {
			filteredElements.add(element)
		}

		return filteredElements
	}


	public var first: Element? {
		return orderedElements.first
	}


	public mutating func formIntersection(_ other: OrderedSet<Element>) {
		remove { !other.contains($0) }
	}


	public mutating func formUnion<S: Sequence>(_ other: S) where S.Iterator.Element == Element {
		for element in other {
			add(element)
		}
	}


	public func index(of member: Element) -> Int? {
		guard elements.contains(member) else {
			return nil
		}

		return orderedElements.firstIndex { $0 == member }
	}


	public func intersection(_ other: OrderedSet<Element>) -> OrderedSet<Element> {
		return filterAsOrderedSet { other.contains($0) }
	}


	public func intersects(_ other: OrderedSet<Element>) -> Bool {
		return contains { other.contains($0) }
	}


	public var isEmpty: Bool {
		return elements.isEmpty
	}


	public func isSubset(of other: OrderedSet<Element>) -> Bool {
		return elements.isSubset(of: other)
	}


	public var last: Element? {
		return orderedElements.last
	}

	
	public func mapAsOrderedSet<MappedElement>(transform: (Element) throws -> MappedElement) rethrows -> OrderedSet<MappedElement> {
		var mappedSet = OrderedSet<MappedElement>(minimumCapacity: count)
		for element in orderedElements {
			mappedSet.add(try transform(element))
		}

		return mappedSet
	}


	public func member(_ member: Element) -> Element? {
		guard let index = elements.firstIndex(of: member) else {
			return nil
		}

		return elements[index]
	}


	public mutating func move(fromIndex: Int, toIndex: Int) {
		precondition(fromIndex >= startIndex && fromIndex < endIndex, "fromIndex outside range \(startIndex) ..< \(endIndex)")
		precondition(toIndex >= startIndex && toIndex < endIndex, "toIndex outside range \(startIndex) ..< \(endIndex)")

		guard fromIndex != toIndex else {
			return
		}

		orderedElements.insert(orderedElements.remove(at: fromIndex), at: toIndex)
	}


	@discardableResult
	public mutating func remove(at index: Int) -> Element {
		let element = orderedElements[index]
		orderedElements.remove(at: index)

		return elements.remove(element)!
	}


	public mutating func remove(where predicate: (Element) throws -> Bool) rethrows {
		subtract(try elements.filter(predicate))
	}


	@discardableResult
	public mutating func remove(_ member: Element) -> Element? {
		guard let index = index(of: member), let removedElement = elements.remove(member) else {
			return nil
		}

		orderedElements.remove(at: index)

		return removedElement
	}


	public mutating func removeAll(keepingCapacity keepCapacity: Bool = false) {
		elements.removeAll(keepingCapacity: keepCapacity)
		orderedElements.removeAll(keepingCapacity: keepCapacity)
	}


	public mutating func subtract<S: Sequence>(_ sequence: S) where S.Iterator.Element == Element {
		for element in sequence {
			remove(element)
		}
	}


	public func subtracting<S: Sequence>(_ sequence: S) -> OrderedSet<Element> where S.Iterator.Element == Element {
		var copy = self
		copy.subtract(sequence)

		return copy
	}


	public func union<S: Sequence>(_ sequence: S) -> OrderedSet<Element> where S.Iterator.Element == Element {
		var copy = self
		copy.formUnion(sequence)

		return copy
	}


	public mutating func update(with newMember: Element) -> Element? {
		guard let index = index(of: newMember), let replacedElement = elements.update(with: newMember) else {
			add(newMember)
			return nil
		}

		orderedElements[index] = newMember

		return replacedElement
	}


	public subscript(bounds: Range<Int>) -> OrderedSet<Element> {
		var set = OrderedSet<Element>()
		for element in orderedElements[bounds] {
			set.add(element)
		}

		return set
	}
}


extension OrderedSet: ExpressibleByArrayLiteral {

	public init(arrayLiteral elements: Element...) {
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


	public subscript(index: Int) -> Element {
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


extension OrderedSet: Hashable {

	public func hash(into hasher: inout Hasher) {
		for element in orderedElements {
			hasher.combine(element)
		}
	}
}


extension OrderedSet: Sequence {

	public typealias Iterator = IndexingIterator<[Element]>


	public func makeIterator() -> Iterator {
		return orderedElements.makeIterator()
	}
}


public func == <Element> (a: OrderedSet<Element>, b: OrderedSet<Element>) -> Bool {
	return a.elements == b.elements
}

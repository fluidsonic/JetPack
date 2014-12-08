import Foundation


public struct Set<T: Hashable>: MutableSetType {

	typealias Element = T

	private var elements: [T : T]


	public init() {
		self.init(minimumCapacity: 2)
	}


	public init(minimumCapacity: Int) {
		elements = [T : T](minimumCapacity: minimumCapacity)
	}


	public init(element: T) {
		self.init(minimumCapacity: 1)

		add(element)
	}


	public init(elements: T...) {
		self.init(minimumCapacity: elements.count)

		union(elements)
	}


	public init<S : SequenceType where S.Generator.Element == T>(elements: S) {
		self.init()

		union(elements)
	}


	public init(_ set: Set<T>) {
		elements = set.elements
	}


	public mutating func add(element: T) -> Bool {
		if contains(element) {
			return false
		}

		elements[element] = element

		return true
	}


	public var any: T? {
		return first(elements.keys)
	}


	public func contains(element: T) -> Bool {
		return (elements[element] != nil)
	}


	public func contains(matches: (T) -> Bool) -> Bool {
		for (element, _) in elements {
			if matches(element) {
				return true
			}
		}

		return false
	}


	public var count: Int {
		return elements.count
	}


	public mutating func filter(includeElement: (T) -> Bool) {
		var excludes = [T]()
		for (element, _) in elements {
			if !includeElement(element) {
				excludes.append(element)
			}
		}

		minus(excludes)
	}


	public func filtered(includeElement: (T) -> Bool) -> Set<T> {
		var newSet = Set<T>()
		for (element, _) in elements {
			if includeElement(element) {
				newSet.add(element)
			}
		}

		return newSet
	}


	public mutating func intersect<S : SetType where S.Element == T>(set: S) {
		filter { set.contains($0) }
	}


	public func intersected<S : SetType where S.Element == T>(set: S) -> Set<T> {
		return filtered { set.contains($0) }
	}


	public func intersects<S : SetType where S.Element == T>(set: S) -> Bool {
		return contains { set.contains($0) }
	}


	public var isEmpty: Bool {
		return elements.isEmpty
	}


	public func isSubsetOf<S : SetType where S.Element == T>(set: S) -> Bool {
		for (element, _) in elements {
			if !set.contains(element) {
				return false
			}
		}

		return true
	}


	public func mapped<U : Hashable>(transform: (T) -> U) -> Set<U> {
		var newSet = Set<U>(minimumCapacity: count)
		for (element, _) in elements {
			newSet.add(transform(element))
		}

		return newSet
	}


	public func member(element: T) -> T? {
		return elements[element]
	}


	public mutating func minus<S : SequenceType where S.Generator.Element == T>(sequence: S) {
		for element in SequenceOf<T>(sequence) {
			remove(element)
		}
	}


	public func minused<S : SequenceType where S.Generator.Element == T>(sequence: S) -> Set<T> {
		var copy = self
		copy.minus(sequence)

		return copy
	}


	public mutating func union<S : SequenceType where S.Generator.Element == T>(sequence: S) {
		for element in SequenceOf<T>(sequence) {
			add(element)
		}
	}


	public func unioned<S : SequenceType where S.Generator.Element == T>(sequence: S) -> Set<T> {
		var copy = self
		copy.union(sequence)

		return copy
	}


	public mutating func remove(element: T) -> T? {
		return elements.removeValueForKey(element)
	}


	public mutating func removeAll() {
		removeAll(keepCapacity: false)
	}


	public mutating func removeAll(#keepCapacity: Bool) {
		elements.removeAll(keepCapacity: keepCapacity)
	}


	public mutating func replace(element: T) -> T? {
		let previousElement = elements[element]
		elements[element] = element

		return previousElement
	}
}


extension Set: ArrayLiteralConvertible {

	public init(arrayLiteral elements: T...) {
		self.init(elements: elements)
	}
}


extension Set: DebugPrintable {

	public var debugDescription: String {
		return description
	}
}


extension Set: Printable {

	public var description: String {
		var description = "Set["

		var isFirstElement = true
		for (key, _) in elements {
			if isFirstElement {
				isFirstElement = false
			}
			else {
				description += ", "
			}

			description += "\(key)"
		}

		description += "]"

		return description
	}
}


extension Set: SequenceType {

	typealias Generator = MapSequenceGenerator<DictionaryGenerator<T, T>, T>


	public func generate() -> Generator {
		return elements.keys.generate()
	}
}


public func ==<T> (a: Set<T>, b: Set<T>) -> Bool {
	if a.count != b.count {
		return false
	}

	for (element, _) in a.elements {
		if !b.contains(element) {
			return false
		}
	}

	return true
}

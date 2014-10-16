import Foundation

struct Set<T : Hashable>: SetType {

	typealias Element = T

	private var elements: [T : T]


	init() {
		self.init(minimumCapacity: 2)
	}


	init(minimumCapacity: Int) {
		elements = [T : T](minimumCapacity: minimumCapacity)
	}


	init(element: T) {
		self.init(minimumCapacity: 1)

		add(element)
	}


	init(elements: T...) {
		self.init(minimumCapacity: elements.count)

		union(elements)
	}


	init<S : SequenceType where S.Generator.Element == T>(elements: S) {
		self.init()

		union(elements)
	}


	init(_ set: Set<T>) {
		elements = set.elements
	}


	mutating func add(element: T) -> Bool {
		if contains(element) {
			return false
		}

		elements[element] = element

		return true
	}


	var any: T? {
		return first(elements.keys)
	}


	func contains(element: T) -> Bool {
		return (elements[element] != nil)
	}


	func contains(matches: (T) -> Bool) -> Bool {
		for (element, _) in elements {
			if matches(element) {
				return true
			}
		}

		return false
	}


	var count: Int {
		return elements.count
	}


	mutating func filter(includeElement: (T) -> Bool) {
		var excludes = [T]()
		for (element, _) in elements {
			if !includeElement(element) {
				excludes.append(element)
			}
		}

		minus(excludes)
	}


	func filtered(includeElement: (T) -> Bool) -> Set<T> {
		var newSet = Set<T>()
		for (element, _) in elements {
			if includeElement(element) {
				newSet.add(element)
			}
		}

		return newSet
	}


	mutating func intersect<S : SetType where S.Element == T>(set: S) {
		filter { set.contains($0) }
	}


	func intersected<S : SetType where S.Element == T>(set: S) -> Set<T> {
		return filtered { set.contains($0) }
	}


	func intersects<S : SetType where S.Element == T>(set: S) -> Bool {
		return contains { set.contains($0) }
	}


	func isSubsetOf<S : SetType where S.Element == T>(set: S) -> Bool {
		for (element, _) in elements {
			if !set.contains(element) {
				return false
			}
		}

		return true
	}


	func mapped<U : Hashable>(transform: (T) -> U) -> Set<U> {
		var newSet = Set<U>(minimumCapacity: count)
		for (element, _) in elements {
			newSet.add(transform(element))
		}

		return newSet
	}


	func member(element: T) -> T? {
		return elements[element]
	}


	mutating func minus<S : SequenceType where S.Generator.Element == T>(sequence: S) {
		for element in SequenceOf<T>(sequence) {
			remove(element)
		}
	}


	func minused<S : SequenceType where S.Generator.Element == T>(sequence: S) -> Set<T> {
		var copy = self
		copy.minus(sequence)

		return copy
	}


	var isEmpty: Bool {
		return elements.isEmpty
	}


	mutating func union<S : SequenceType where S.Generator.Element == T>(sequence: S) {
		for element in SequenceOf<T>(sequence) {
			add(element)
		}
	}


	func unioned<S : SequenceType where S.Generator.Element == T>(sequence: S) -> Set<T> {
		var copy = self
		copy.union(sequence)

		return copy
	}


	mutating func remove(element: T) -> T? {
		return elements.removeValueForKey(element)
	}


	mutating func removeAll() {
		removeAll(keepCapacity: false)
	}


	mutating func removeAll(#keepCapacity: Bool) {
		elements.removeAll(keepCapacity: keepCapacity)
	}


	mutating func replace(element: T) -> T? {
		let previousElement = elements[element]
		elements[element] = element

		return previousElement
	}
}


extension Set: ArrayLiteralConvertible {

	init(arrayLiteral elements: T...) {
		self.init(elements: elements)
	}
}


extension Set: DebugPrintable {

	var debugDescription: String {
		return description
	}
}


extension Set: Printable {

	var description: String {
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


	func generate() -> Generator {
		return elements.keys.generate()
	}
}


func ==<T> (a: Set<T>, b: Set<T>) -> Bool {
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

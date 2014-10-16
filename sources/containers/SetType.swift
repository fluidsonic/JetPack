import Foundation


public protocol SetType : ArrayLiteralConvertible, Equatable, SequenceType {

	typealias Element

	var any:     Element? { get }
	var count:   Int      { get }
	var isEmpty: Bool     { get }

	init()
	init(element: Element)
	init(elements: Element...)
	init<S : SequenceType where S.Generator.Element == Element>(elements: S)
	init(minimumCapacity: Int)

	func contains(element: Element) -> Bool
	func contains(matches: (Element) -> Bool) -> Bool
	func filtered(includeElement: (Element) -> Bool) -> Self
	func intersected<S : SetType where S.Element == Element>(set: S) -> Self
	func intersects<S : SetType where S.Element == Element>(set: S) -> Bool
	func isSubsetOf<S : SetType where S.Element == Element>(set: S) -> Bool
	// func mapped<U : Hashable, S : SetType where S.Element == U>(transform: (Element) -> U) -> S  // bug in Swift what `Set<U>` does not match `S : SetType where S.Element == U`?
	func member(element: Element) -> Element?
	func minused<S : SequenceType where S.Generator.Element == Element>(sequence: S) -> Self
	func unioned<S : SequenceType where S.Generator.Element == Element>(sequence: S) -> Self

	mutating func add(element: Element) -> Bool
	mutating func filter(includeElement: (Element) -> Bool)
	mutating func intersect<S : SetType where S.Element == Element>(set: S)
	mutating func minus<S : SequenceType where S.Generator.Element == Element>(sequence: S)
	mutating func replace(element: Element) -> Element?
	mutating func remove(element: Element) -> Element?
	mutating func removeAll()
	mutating func union<S : SequenceType where S.Generator.Element == Element>(sequence: S)
}


// crashes compiler (last tested Xcode 6.1 GM 2)
/*
extension NSSet {

	convenience init<S: SetType>(set: S) {
		self.init(array: Array(set))
	}
}


extension NSMutableSet {

	convenience init<S: SetType>(set: S) {
		self.init(array: Array(set))
	}
}
*/

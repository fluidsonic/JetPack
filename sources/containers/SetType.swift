import Foundation


public protocol SetType: ArrayLiteralConvertible, Equatable, SequenceType {

	typealias Element

	var any:     Element? { get }
	var count:   Int      { get }
	var isEmpty: Bool     { get }

	init()
	init(element: Element)
	init(elements: Element...)
	init<S : SequenceType where S.Generator.Element == Element>(sequence: S)
	init(minimumCapacity: Int)

	func contains(element: Element) -> Bool
	func contains(matches: (Element) -> Bool) -> Bool
	func filtered(includeElement: (Element) -> Bool) -> Self
	func intersected<S: SetType where S.Element == Element>(set: S) -> Self
	func intersects<S: SetType where S.Element == Element>(set: S) -> Bool
	func isSubsetOf<S: SetType where S.Element == Element>(set: S) -> Bool
	// func mapped<U : Hashable, S : SetType where S.Element == U>(transform: (Element) -> U) -> S  // bug in Swift what `Set<U>` does not match `S : SetType where S.Element == U`?
	func member(element: Element) -> Element?
	func minused<S: SequenceType where S.Generator.Element == Element>(sequence: S) -> Self
	func unioned<S: SequenceType where S.Generator.Element == Element>(sequence: S) -> Self
}

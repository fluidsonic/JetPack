import Foundation


public protocol MutableSetType: SetType {

	mutating func add(element: Self.Element) -> Bool
	mutating func filter(includeElement: (Self.Element) -> Bool)
	mutating func intersect<S: SetType where S.Element == Element>(set: S)
	mutating func minus<S: SequenceType where S.Generator.Element == Element>(sequence: S)
	mutating func replace(element: Self.Element) -> Self.Element?
	mutating func remove(element: Self.Element) -> Self.Element?
	mutating func removeAll()
	mutating func union<S: SequenceType where S.Generator.Element == Element>(sequence: S)
}

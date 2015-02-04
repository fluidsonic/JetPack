import Foundation


public extension NSSet {

	public var isEmpty: Bool {
		return (count == 0)
	}


	public func sequenceOf<T>(type: T.Type) -> SequenceOf<T> {
		let generator = generate()

		return SequenceOf(GeneratorOf() {
			return generator.next() as T?
		})
	}
}

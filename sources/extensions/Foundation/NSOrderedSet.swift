import Foundation


public extension NSOrderedSet {

	public convenience init<S: SequenceType where S.Generator.Element: AnyObject>(elements: S) {
		self.init(array: Array(elements))
	}


	public var isEmpty: Bool {
		return (count == 0)
	}


	public func reversedSequenceOf<T>(type: T.Type) -> SequenceOf<T> {
		let generator = NSFastGenerator(reverseObjectEnumerator())

		return SequenceOf(GeneratorOf() {
			return generator.next() as! T?
		})
	}


	public func sequenceOf<T>(type: T.Type) -> SequenceOf<T> {
		let generator = generate()

		return SequenceOf(GeneratorOf() {
			return generator.next() as! T?
		})
	}
}


extension NSOrderedSet: SequenceType {

	public func generate() -> NSFastGenerator {
		return NSFastGenerator(self)
	}
}

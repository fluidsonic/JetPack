import Foundation


public extension NSOrderedSet {

	@nonobjc
	public convenience init<S: SequenceType where S.Generator.Element: AnyObject>(elements: S) {
		self.init(array: Array(elements))
	}


	@nonobjc
	public var isEmpty: Bool {
		return (count == 0)
	}
}

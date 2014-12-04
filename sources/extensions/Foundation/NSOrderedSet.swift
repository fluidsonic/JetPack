import Foundation


public extension NSOrderedSet {

	public convenience init<S: SequenceType where S.Generator.Element: AnyObject>(elements: S) {
		self.init(array: Array(elements))
	}
}

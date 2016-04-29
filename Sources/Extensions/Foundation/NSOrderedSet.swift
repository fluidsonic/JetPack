import Foundation


public extension NSOrderedSet {

	@nonobjc
	public convenience init<S: SequenceType where S.Generator.Element: AnyObject>(elements: S) {
		self.init(array: Array(elements))
	}


	@nonobjc
	public var indices: Range<Int> {
		return 0 ..< count
	}


	@nonobjc
	public var isEmpty: Bool {
		return (count == 0)
	}


	@nonobjc
	public subscript(safe index: Int) -> Generator.Element? {
		return indices.contains(index) ? self[index] : nil
	}
}

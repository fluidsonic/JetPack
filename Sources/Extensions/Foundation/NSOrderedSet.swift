import Foundation


public extension NSOrderedSet {

	@nonobjc
	public convenience init<S: Sequence>(elements: S) {
		self.init(array: Array(elements))
	}


	@nonobjc
	public var indices: CountableRange<Int> {
		return 0 ..< count
	}


	@nonobjc
	public var isEmpty: Bool {
		return (count == 0)
	}


	@nonobjc
	public subscript(safe index: Int) -> Iterator.Element? {
		return indices.contains(index) ? self[index] : nil
	}
}

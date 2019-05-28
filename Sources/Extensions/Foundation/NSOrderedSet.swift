import Foundation


public extension NSOrderedSet {

	@nonobjc
	convenience init<S: Sequence>(elements: S) {
		self.init(array: Array(elements))
	}


	@nonobjc
	var indices: CountableRange<Int> {
		return 0 ..< count
	}


	@nonobjc
	var isEmpty: Bool {
		return (count == 0)
	}


	@nonobjc
	subscript(safe index: Int) -> Iterator.Element? {
		return indices.contains(index) ? self[index] : nil
	}
}

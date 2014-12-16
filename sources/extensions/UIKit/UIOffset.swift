import UIKit


public extension UIOffset {

	public static let zeroOffset = UIOffsetZero

}


extension UIOffset: Equatable {}



public func == (a: UIOffset, b: UIOffset) -> Bool {
	return (a.horizontal == b.horizontal) && (a.vertical == b.vertical)
}

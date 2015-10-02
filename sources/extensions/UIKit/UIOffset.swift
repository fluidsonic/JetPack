import UIKit


public extension UIOffset {

	public static let zero = UIOffset()
}



public extension CGPoint {

	@warn_unused_result(mutable_variant="offsetInPlace")
	public func offsetBy(offset: UIOffset) -> CGPoint {
		return CGPoint(x: x + offset.horizontal, y: y + offset.vertical)
	}


	public mutating func offsetInPlace(offset: UIOffset) {
		self = offsetBy(offset)
	}
}



public extension CGRect {

	@warn_unused_result(mutable_variant="offsetInPlace")
	public func offsetBy(offset: UIOffset) -> CGRect {
		return CGRect(left: left + offset.horizontal, top: top + offset.vertical, width: width, height: height)
	}


	public mutating func offsetInPlace(offset: UIOffset) {
		self = offsetBy(offset)
	}
}

import UIKit


public extension UIOffset {

	public static let zero = UIOffset()


	public init(horizontal: CGFloat) {
		self.init(horizontal: horizontal, vertical: 0)
	}


	public init(vertical: CGFloat) {
		self.init(horizontal: 0, vertical: vertical)
	}


	@warn_unused_result(mutable_variant="scaleInPlace")
	public func scaleBy(scale: CGFloat) -> UIOffset {
		return UIOffset(horizontal: horizontal * scale, vertical: vertical * scale)
	}


	public mutating func scaleInPlace(scale: CGFloat) {
		self = scaleBy(scale)
	}
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

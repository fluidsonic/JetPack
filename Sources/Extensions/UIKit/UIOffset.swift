import UIKit


public extension UIOffset {

	public init(horizontal: CGFloat) {
		self.init(horizontal: horizontal, vertical: 0)
	}


	public init(vertical: CGFloat) {
		self.init(horizontal: 0, vertical: vertical)
	}


	
	public func scaleBy(_ scale: CGFloat) -> UIOffset {
		return UIOffset(horizontal: horizontal * scale, vertical: vertical * scale)
	}


	public mutating func scaleInPlace(_ scale: CGFloat) {
		self = scaleBy(scale)
	}
}



public extension CGPoint {

	
	public func offsetBy(_ offset: UIOffset) -> CGPoint {
		return CGPoint(x: x + offset.horizontal, y: y + offset.vertical)
	}


	public mutating func offsetInPlace(_ offset: UIOffset) {
		self = offsetBy(offset)
	}
}



public extension CGRect {

	
	public func offsetBy(_ offset: UIOffset) -> CGRect {
		return CGRect(left: left + offset.horizontal, top: top + offset.vertical, width: width, height: height)
	}


	public mutating func offsetInPlace(_ offset: UIOffset) {
		self = offsetBy(offset)
	}
}

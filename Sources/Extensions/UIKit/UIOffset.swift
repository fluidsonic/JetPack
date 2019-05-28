import UIKit


public extension UIOffset {

	init(horizontal: CGFloat) {
		self.init(horizontal: horizontal, vertical: 0)
	}


	init(vertical: CGFloat) {
		self.init(horizontal: 0, vertical: vertical)
	}


	
	func scaleBy(_ scale: CGFloat) -> UIOffset {
		return UIOffset(horizontal: horizontal * scale, vertical: vertical * scale)
	}


	mutating func scaleInPlace(_ scale: CGFloat) {
		self = scaleBy(scale)
	}
}



public extension CGPoint {

	
	func offsetBy(_ offset: UIOffset) -> CGPoint {
		return CGPoint(x: x + offset.horizontal, y: y + offset.vertical)
	}


	mutating func offsetInPlace(_ offset: UIOffset) {
		self = offsetBy(offset)
	}
}



public extension CGRect {

	
	func offsetBy(_ offset: UIOffset) -> CGRect {
		return CGRect(left: left + offset.horizontal, top: top + offset.vertical, width: width, height: height)
	}


	mutating func offsetInPlace(_ offset: UIOffset) {
		self = offsetBy(offset)
	}
}

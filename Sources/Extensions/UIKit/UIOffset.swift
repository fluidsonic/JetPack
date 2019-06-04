import UIKit


public extension UIOffset {

	init(horizontal: CGFloat) {
		self.init(horizontal: horizontal, vertical: 0)
	}


	init(vertical: CGFloat) {
		self.init(horizontal: 0, vertical: vertical)
	}


	func scale(by scale: CGFloat) -> UIOffset {
		return UIOffset(horizontal: horizontal * scale, vertical: vertical * scale)
	}


	@available(*, unavailable, renamed: "scale(by:)")
	func scaleBy(_ scale: CGFloat) -> UIOffset {
		return self.scale(by: scale)
	}


	@available(*, deprecated, message: "offset = offset.scale(by: …)")
	mutating func scaleInPlace(_ scale: CGFloat) {
		self = self.scale(by: scale)
	}


	static prefix func - (_ offset: UIOffset) -> UIOffset {
		return UIOffset(horizontal: -offset.horizontal, vertical: -offset.vertical)
	}


	static func + (_ lhs: UIOffset, _ rhs: UIOffset) -> UIOffset {
		return UIOffset(horizontal: lhs.horizontal + rhs.horizontal, vertical: lhs.vertical + rhs.vertical)
	}


	static func += (_ lhs: inout UIOffset, _ rhs: UIOffset) {
		lhs = lhs + rhs
	}


	static func - (_ lhs: UIOffset, _ rhs: UIOffset) -> UIOffset {
		return UIOffset(horizontal: lhs.horizontal - rhs.horizontal, vertical: lhs.vertical - rhs.vertical)
	}


	static func -= (_ lhs: inout UIOffset, _ rhs: UIOffset) {
		lhs = lhs - rhs
	}
}



public extension CGPoint {

	@available(*, unavailable, message: "+")
	func offsetBy(_ offset: UIOffset) -> CGPoint {
		return self + offset
	}


	@available(*, deprecated, message: "point += …")
	mutating func offsetInPlace(_ offset: UIOffset) {
		self += offset
	}


	static func + (_ lhs: CGPoint, _ rhs: UIOffset) -> CGPoint {
		return CGPoint(x: lhs.x + rhs.horizontal, y: lhs.y + rhs.vertical)
	}


	static func += (_ lhs: inout CGPoint, _ rhs: UIOffset) {
		lhs = lhs + rhs
	}


	static func - (_ lhs: CGPoint, _ rhs: UIOffset) -> CGPoint {
		return CGPoint(x: lhs.x - rhs.horizontal, y: lhs.y - rhs.vertical)
	}


	static func -= (_ lhs: inout CGPoint, _ rhs: UIOffset) {
		lhs = lhs - rhs
	}
}



public extension CGRect {

	@available(*, unavailable, message: "+")
	func offsetBy(_ offset: UIOffset) -> CGRect {
		return self + offset
	}


	@available(*, deprecated, message: "rect += …")
	mutating func offsetInPlace(_ offset: UIOffset) {
		self += offset
	}


	static func + (_ lhs: CGRect, _ rhs: UIOffset) -> CGRect {
		return lhs.offsetBy(dx: rhs.horizontal, dy: rhs.vertical)
	}


	static func += (_ lhs: inout CGRect, _ rhs: UIOffset) {
		lhs = lhs + rhs
	}


	static func - (_ lhs: CGRect, _ rhs: UIOffset) -> CGRect {
		return lhs + -rhs
	}


	static func -= (_ lhs: inout CGRect, _ rhs: UIOffset) {
		lhs = lhs - rhs
	}
}

import CoreGraphics


public extension CGPoint {

	public init(left: CGFloat, top: CGFloat) {
		self.init(x: left, y: top)
	}


	public var left: CGFloat {
		get { return x }
		set { x = newValue }
	}


	public func pointByOffsetting(offset: CGPoint) -> CGPoint {
		return CGPoint(x: x + offset.x, y: y + offset.y)
	}


	public func pointByOffsetting(dx dx: CGFloat, dy: CGFloat) -> CGPoint {
		return CGPoint(x: x + dx, y: dy)
	}


	public func pointByOffsetting(dx dx: CGFloat) -> CGPoint {
		return CGPoint(x: x + dx, y: y)
	}


	public func pointByOffsetting(dy dy: CGFloat) -> CGPoint {
		return CGPoint(x: x, y: y + dy)
	}


	public var top: CGFloat {
		get { return y }
		set { y = newValue }
	}
}

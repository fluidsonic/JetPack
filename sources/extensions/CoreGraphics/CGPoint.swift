import CoreGraphics


public extension CGPoint {

	public init(left: CGFloat, top: CGFloat) {
		self.init(x: left, y: top)
	}


	@warn_unused_result
	public func displacementTo(point: CGPoint) -> CGPoint {
		return CGPoint(x: point.x - x, y: point.y - y)
	}


	@warn_unused_result
	public func distanceTo(point: CGPoint) -> CGFloat {
		let displacement = displacementTo(point)
		return sqrt((displacement.x * displacement.x) + (displacement.y * displacement.y))
	}


	public var left: CGFloat {
		get { return x }
		set { x = newValue }
	}


	@warn_unused_result(mutable_variant="offsetInPlace")
	public func offsetBy(offset: CGPoint) -> CGPoint {
		return CGPoint(x: x + offset.x, y: y + offset.y)
	}


	@warn_unused_result(mutable_variant="offsetInPlace")
	public func offsetBy(dx dx: CGFloat, dy: CGFloat) -> CGPoint {
		return CGPoint(x: x + dx, y: y + dy)
	}


	@warn_unused_result
	public func offsetBy(dx dx: CGFloat) -> CGPoint {
		return CGPoint(x: x + dx, y: y)
	}


	@warn_unused_result
	public func offsetBy(dy dy: CGFloat) -> CGPoint {
		return CGPoint(x: x, y: y + dy)
	}


	public mutating func offsetInPlace(offset: CGPoint) {
		self = offsetBy(offset)
	}


	public mutating func offsetInPlace(dx dx: CGFloat, dy: CGFloat) {
		self = offsetBy(dx: dx, dy: dy)
	}


	public var top: CGFloat {
		get { return y }
		set { y = newValue }
	}
}

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
	public func offsetBy(dx dx: CGFloat, dy: CGFloat) -> CGPoint {
		return CGPoint(x: x + dx, y: y + dy)
	}


	@warn_unused_result
	public func offsetBy(dx dx: CGFloat) -> CGPoint {
		return offsetBy(dx: dx, dy: 0)
	}


	@warn_unused_result
	public func offsetBy(dy dy: CGFloat) -> CGPoint {
		return offsetBy(dx: 0, dy: dy)
	}


	@warn_unused_result(mutable_variant="offsetInPlace")
	public func offsetBy(offset: CGPoint) -> CGPoint {
		return offsetBy(dx: offset.x, dy: offset.y)
	}


	public mutating func offsetInPlace(dx dx: CGFloat, dy: CGFloat) {
		self = offsetBy(dx: dx, dy: dy)
	}


	public mutating func offsetInPlace(dx dx: CGFloat) {
		self = offsetBy(dx: dx)
	}


	public mutating func offsetInPlace(dy dy: CGFloat) {
		self = offsetBy(dy: dy)
	}


	public mutating func offsetInPlace(offset: CGPoint) {
		self = offsetBy(offset)
	}


	public var top: CGFloat {
		get { return y }
		set { y = newValue }
	}


	@warn_unused_result(mutable_variant="transformInPlace")
	public func transform(transform: CGAffineTransform) -> CGPoint {
		return CGPointApplyAffineTransform(self, transform)
	}


	public mutating func transformInPlace(transform: CGAffineTransform) {
		self = self.transform(transform)
	}
}

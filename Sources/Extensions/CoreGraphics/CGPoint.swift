import CoreGraphics


public extension CGPoint {

	public init(left: CGFloat, top: CGFloat) {
		self.init(x: left, y: top)
	}


	
	public func clamp(min: CGPoint, max: CGPoint) -> CGPoint {
		return CGPoint(x: x.coerced(in: min.x ... max.x), y: y.coerced(in: min.y ... max.y))
	}


	
	public func displacementTo(_ point: CGPoint) -> CGPoint {
		return CGPoint(x: point.x - x, y: point.y - y)
	}


	
	public func distanceTo(_ point: CGPoint) -> CGFloat {
		let displacement = displacementTo(point)
		return sqrt((displacement.x * displacement.x) + (displacement.y * displacement.y))
	}


	public var left: CGFloat {
		get { return x }
		set { x = newValue }
	}


	
	public func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
		return CGPoint(x: x + dx, y: y + dy)
	}


	
	public func offsetBy(dx: CGFloat) -> CGPoint {
		return offsetBy(dx: dx, dy: 0)
	}


	
	public func offsetBy(dy: CGFloat) -> CGPoint {
		return offsetBy(dx: 0, dy: dy)
	}


	
	public func offsetBy(_ offset: CGPoint) -> CGPoint {
		return offsetBy(dx: offset.x, dy: offset.y)
	}


	public mutating func offsetInPlace(dx: CGFloat, dy: CGFloat) {
		self = offsetBy(dx: dx, dy: dy)
	}


	public mutating func offsetInPlace(dx: CGFloat) {
		self = offsetBy(dx: dx)
	}


	public mutating func offsetInPlace(dy: CGFloat) {
		self = offsetBy(dy: dy)
	}


	public mutating func offsetInPlace(_ offset: CGPoint) {
		self = offsetBy(offset)
	}


	public var top: CGFloat {
		get { return y }
		set { y = newValue }
	}


	
	public func transform(_ transform: CGAffineTransform) -> CGPoint {
		return self.applying(transform)
	}


	public mutating func transformInPlace(_ transform: CGAffineTransform) {
		self = self.transform(transform)
	}
}

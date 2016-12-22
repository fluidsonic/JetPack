import CoreGraphics


public extension CGPoint {

	public init(left: CGFloat, top: CGFloat) {
		self.init(x: left, y: top)
	}


	public func coerced(min: CGPoint, max: CGPoint) -> CGPoint {
		return CGPoint(x: x.coerced(in: min.x ... max.x), y: y.coerced(in: min.y ... max.y))
	}


	public func displacement(to point: CGPoint) -> CGPoint {
		return CGPoint(x: point.x - x, y: point.y - y)
	}


	public func distance(to point: CGPoint) -> CGFloat {
		let displacement = self.displacement(to: point)
		return ((displacement.x * displacement.x) + (displacement.y * displacement.y)).squareRoot()
	}


	public var left: CGFloat {
		get { return x }
		set { x = newValue }
	}


	public func offsetBy(_ offset: CGPoint) -> CGPoint {
		return offsetBy(dx: offset.x, dy: offset.y)
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


	public var top: CGFloat {
		get { return y }
		set { y = newValue }
	}
}

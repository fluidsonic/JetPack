import CoreGraphics


public extension CGPoint {

	public func pointByOffsetting(offset: CGPoint) -> CGPoint {
		return CGPoint(x: x + offset.x, y: y + offset.y)
	}

	public func pointByOffsetting(#dx: CGFloat, dy: CGFloat) -> CGPoint {
		return CGPoint(x: x + dx, y: dy)
	}

	public func pointByOffsetting(#dx: CGFloat) -> CGPoint {
		return CGPoint(x: x + dx, y: y)
	}

	public func pointByOffsetting(#dy: CGFloat) -> CGPoint {
		return CGPoint(x: x, y: y + dy)
	}
}

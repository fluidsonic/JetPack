import CoreGraphics


extension CGPoint {

	func pointByOffsetting(offset: CGPoint) -> CGPoint {
		return CGPoint(x: x + offset.x, y: y + offset.y)
	}

	func pointByOffsetting(#dx: CGFloat, dy: CGFloat) -> CGPoint {
		return CGPoint(x: x + dx, y: dy)
	}

	func pointByOffsetting(#dx: CGFloat) -> CGPoint {
		return CGPoint(x: x + dx, y: y)
	}

	func pointByOffsetting(#dy: CGFloat) -> CGPoint {
		return CGPoint(x: x, y: y + dy)
	}
}

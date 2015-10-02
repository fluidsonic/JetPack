import UIKit


public extension UIBezierPath {

	public convenience init(animatableRoundedRect: CGRect, cornerRadius: CGFloat) {
		self.init()

		moveToPoint(CGPoint(left: animatableRoundedRect.left + cornerRadius, top: animatableRoundedRect.top))
		addLineToPoint(CGPoint(left: animatableRoundedRect.right - cornerRadius, top: animatableRoundedRect.top))
		addRoundedCorner(direction: .RightDown, radius: cornerRadius)
		addLineToPoint(CGPoint(left: animatableRoundedRect.right, top: animatableRoundedRect.bottom - cornerRadius))
		addRoundedCorner(direction: .DownLeft, radius: cornerRadius)
		addLineToPoint(CGPoint(left: animatableRoundedRect.left + cornerRadius, top: animatableRoundedRect.bottom))
		addRoundedCorner(direction: .LeftUp, radius: cornerRadius)
		addLineToPoint(CGPoint(left: animatableRoundedRect.left, top: animatableRoundedRect.top + cornerRadius))
		addRoundedCorner(direction: .UpRight, radius: cornerRadius)
	}


	public func addRoundedCorner(direction direction: RoundedCornerDirection, radius: CGFloat) {
		if radius <= 0 {
			return
		}

		var center: CGPoint
		var clockwise: Bool
		var endAngle: CGFloat
		var startAngle: CGFloat

		switch direction {
		case .DownLeft:
			center = currentPoint.offsetBy(dx: -radius)
			clockwise = true
			endAngle = CGMath.radiansBottom
			startAngle = CGMath.radiansRight

		case .DownRight:
			center = currentPoint.offsetBy(dx: radius)
			clockwise = false
			endAngle = CGMath.radiansBottom
			startAngle = CGMath.radiansLeft

		case .LeftDown:
			center = currentPoint.offsetBy(dy: radius)
			clockwise = false
			endAngle = CGMath.radiansLeft
			startAngle = CGMath.radiansTop

		case .LeftUp:
			center = currentPoint.offsetBy(dy: -radius)
			clockwise = true
			endAngle = CGMath.radiansLeft
			startAngle = CGMath.radiansBottom

		case .RightDown:
			center = currentPoint.offsetBy(dy: radius)
			clockwise = true
			endAngle = CGMath.radiansRight
			startAngle = CGMath.radiansTop

		case .RightUp:
			center = currentPoint.offsetBy(dy: -radius)
			clockwise = false
			endAngle = CGMath.radiansRight
			startAngle = CGMath.radiansBottom

		case .UpLeft:
			center = currentPoint.offsetBy(dx: -radius)
			clockwise = false
			endAngle = CGMath.radiansTop
			startAngle = CGMath.radiansRight

		case .UpRight:
			center = currentPoint.offsetBy(dx: radius)
			clockwise = true
			endAngle = CGMath.radiansTop
			startAngle = CGMath.radiansLeft
		}

		addArcWithCenter(center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
	}


	private func centerForRoundedCorner(direction direction: RoundedCornerDirection, radius: CGFloat) -> CGPoint {
		switch direction {
		case .LeftDown, .RightDown:
			return currentPoint.offsetBy(dy: radius)

		case .LeftUp, .RightUp:
			return currentPoint.offsetBy(dy: -radius)

		case .DownLeft, .UpLeft:
			return currentPoint.offsetBy(dx: -radius)

		case .DownRight, .UpRight:
			return currentPoint.offsetBy(dx: radius)
		}
	}


	private class func endAngleForRoundedCorner(direction direction: RoundedCornerDirection) -> CGFloat {
		switch direction {
		case .DownLeft, .DownRight:
			return CGMath.radiansBottom

		case .LeftDown, .LeftUp:
			return CGMath.radiansLeft

		case .RightDown, .RightUp:
			return CGMath.radiansRight

		case .UpLeft, .UpRight:
			return CGMath.radiansTop
		}
	}


	@warn_unused_result
	public func invertedBezierPathInRect(rect: CGRect) -> UIBezierPath {
		let path = UIBezierPath(rect: rect)
		path.usesEvenOddFillRule = true
		path.appendPath(self)

		return path
	}


	private class func roundedCornerIsClockwise(direction direction: RoundedCornerDirection) -> Bool {
		switch direction {
		case .UpRight, .RightDown, .DownLeft, .LeftUp:
			return true

		case .LeftDown, .DownRight, .RightUp, .UpLeft:
			return false
		}
	}


	private class func startAngleForRoundedCorner(direction direction: RoundedCornerDirection) -> CGFloat {
		switch direction {
		case .DownLeft, .UpLeft:
			return CGMath.radiansRight

		case .DownRight, .UpRight:
			return CGMath.radiansLeft

		case .LeftDown, .RightDown:
			return CGMath.radiansTop

		case .LeftUp, .RightUp:
			return CGMath.radiansBottom
		}
	}

	

	public enum RoundedCornerDirection {
		case DownLeft
		case DownRight
		case LeftDown
		case LeftUp
		case RightDown
		case RightUp
		case UpLeft
		case UpRight
	}
}

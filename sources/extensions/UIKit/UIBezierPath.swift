import UIKit


public extension UIBezierPath {

	public func addRoundedCorner(#direction: RoundedCornerDirection, radius: CGFloat) {
		if radius <= 0 {
			return
		}

		var center: CGPoint
		var clockwise: Bool
		var endAngle: CGFloat
		var startAngle: CGFloat

		switch direction {
		case .DownLeft:
			center = currentPoint.pointByOffsetting(dx: -radius)
			clockwise = true
			endAngle = CGMath.radiansBottom
			startAngle = CGMath.radiansRight

		case .DownRight:
			center = currentPoint.pointByOffsetting(dx: radius)
			clockwise = false
			endAngle = CGMath.radiansBottom
			startAngle = CGMath.radiansLeft

		case .LeftDown:
			center = currentPoint.pointByOffsetting(dy: radius)
			clockwise = false
			endAngle = CGMath.radiansLeft
			startAngle = CGMath.radiansTop

		case .LeftUp:
			center = currentPoint.pointByOffsetting(dy: -radius)
			clockwise = true
			endAngle = CGMath.radiansLeft
			startAngle = CGMath.radiansBottom

		case .RightDown:
			center = currentPoint.pointByOffsetting(dy: radius)
			clockwise = true
			endAngle = CGMath.radiansRight
			startAngle = CGMath.radiansTop

		case .RightUp:
			center = currentPoint.pointByOffsetting(dy: -radius)
			clockwise = false
			endAngle = CGMath.radiansRight
			startAngle = CGMath.radiansBottom

		case .UpLeft:
			center = currentPoint.pointByOffsetting(dx: -radius)
			clockwise = false
			endAngle = CGMath.radiansTop
			startAngle = CGMath.radiansRight

		case .UpRight:
			center = currentPoint.pointByOffsetting(dx: radius)
			clockwise = true
			endAngle = CGMath.radiansTop
			startAngle = CGMath.radiansLeft
		}

		addArcWithCenter(center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
	}


	private func centerForRoundedCorner(#direction: RoundedCornerDirection, radius: CGFloat) -> CGPoint {
		switch direction {
		case .LeftDown, .RightDown:
			return currentPoint.pointByOffsetting(dy: radius)

		case .LeftUp, .RightUp:
			return currentPoint.pointByOffsetting(dy: -radius)

		case .DownLeft, .UpLeft:
			return currentPoint.pointByOffsetting(dx: -radius)

		case .DownRight, .UpRight:
			return currentPoint.pointByOffsetting(dx: radius)
		}
	}


	private class func endAngleForRoundedCorner(#direction: RoundedCornerDirection) -> CGFloat {
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


	private class func roundedCornerIsClockwise(#direction: RoundedCornerDirection) -> Bool {
		switch direction {
		case .UpRight, .RightDown, .DownLeft, .LeftUp:
			return true

		case .LeftDown, .DownRight, .RightUp, .UpLeft:
			return false
		}
	}


	private class func startAngleForRoundedCorner(#direction: RoundedCornerDirection) -> CGFloat {
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

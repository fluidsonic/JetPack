import UIKit


public extension UIBezierPath {

	@nonobjc
	convenience init(animatableRoundedRect rect: CGRect, cornerRadii: CornerRadii = .zero) {
		self.init()

		move(to: CGPoint(left: rect.left + cornerRadii.topLeft, top: rect.top))
		addLine(to: CGPoint(left: rect.right - cornerRadii.topRight, top: rect.top))
		addRoundedCorner(direction: .rightDown, radius: cornerRadii.topRight)
		addLine(to: CGPoint(left: rect.right, top: rect.bottom - cornerRadii.bottomRight))
		addRoundedCorner(direction: .downLeft, radius: cornerRadii.bottomRight)
		addLine(to: CGPoint(left: rect.left + cornerRadii.bottomLeft, top: rect.bottom))
		addRoundedCorner(direction: .leftUp, radius: cornerRadii.bottomLeft)
		addLine(to: CGPoint(left: rect.left, top: rect.top + cornerRadii.topLeft))
		addRoundedCorner(direction: .upRight, radius: cornerRadii.topLeft)
	}


	@nonobjc
	func addRoundedCorner(direction: RoundedCornerDirection, radius requestedRadius: CGFloat) {
		let radius = max(requestedRadius, 0)

		var center: CGPoint
		var clockwise: Bool
		var endAngle: CGFloat
		var startAngle: CGFloat

		switch direction {
		case .downLeft:
			center = currentPoint.offsetBy(dx: -radius)
			clockwise = true
			endAngle = CGMath.radiansBottom
			startAngle = CGMath.radiansRight

		case .downRight:
			center = currentPoint.offsetBy(dx: radius)
			clockwise = false
			endAngle = CGMath.radiansBottom
			startAngle = CGMath.radiansLeft

		case .leftDown:
			center = currentPoint.offsetBy(dy: radius)
			clockwise = false
			endAngle = CGMath.radiansLeft
			startAngle = CGMath.radiansTop

		case .leftUp:
			center = currentPoint.offsetBy(dy: -radius)
			clockwise = true
			endAngle = CGMath.radiansLeft
			startAngle = CGMath.radiansBottom

		case .rightDown:
			center = currentPoint.offsetBy(dy: radius)
			clockwise = true
			endAngle = CGMath.radiansRight
			startAngle = CGMath.radiansTop

		case .rightUp:
			center = currentPoint.offsetBy(dy: -radius)
			clockwise = false
			endAngle = CGMath.radiansRight
			startAngle = CGMath.radiansBottom

		case .upLeft:
			center = currentPoint.offsetBy(dx: -radius)
			clockwise = false
			endAngle = CGMath.radiansTop
			startAngle = CGMath.radiansRight

		case .upRight:
			center = currentPoint.offsetBy(dx: radius)
			clockwise = true
			endAngle = CGMath.radiansTop
			startAngle = CGMath.radiansLeft
		}

		addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
	}


	fileprivate func centerForRoundedCorner(direction: RoundedCornerDirection, radius: CGFloat) -> CGPoint {
		switch direction {
		case .leftDown, .rightDown:
			return currentPoint.offsetBy(dy: radius)

		case .leftUp, .rightUp:
			return currentPoint.offsetBy(dy: -radius)

		case .downLeft, .upLeft:
			return currentPoint.offsetBy(dx: -radius)

		case .downRight, .upRight:
			return currentPoint.offsetBy(dx: radius)
		}
	}


	fileprivate class func endAngleForRoundedCorner(direction: RoundedCornerDirection) -> CGFloat {
		switch direction {
		case .downLeft, .downRight:
			return CGMath.radiansBottom

		case .leftDown, .leftUp:
			return CGMath.radiansLeft

		case .rightDown, .rightUp:
			return CGMath.radiansRight

		case .upLeft, .upRight:
			return CGMath.radiansTop
		}
	}


	@nonobjc
	
	func invertedBezierPathInRect(_ rect: CGRect) -> UIBezierPath {
		let path = UIBezierPath(rect: rect)
		path.usesEvenOddFillRule = true
		path.append(self)

		return path
	}


	fileprivate class func roundedCornerIsClockwise(direction: RoundedCornerDirection) -> Bool {
		switch direction {
		case .upRight, .rightDown, .downLeft, .leftUp:
			return true

		case .leftDown, .downRight, .rightUp, .upLeft:
			return false
		}
	}


	fileprivate class func startAngleForRoundedCorner(direction: RoundedCornerDirection) -> CGFloat {
		switch direction {
		case .downLeft, .upLeft:
			return CGMath.radiansRight

		case .downRight, .upRight:
			return CGMath.radiansLeft

		case .leftDown, .rightDown:
			return CGMath.radiansTop

		case .leftUp, .rightUp:
			return CGMath.radiansBottom
		}
	}

	

	enum RoundedCornerDirection {
		case downLeft
		case downRight
		case leftDown
		case leftUp
		case rightDown
		case rightUp
		case upLeft
		case upRight
	}
}

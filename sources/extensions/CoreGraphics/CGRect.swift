import CoreGraphics


public extension CGRect {

	public init(size: CGSize) {
		self.init(x: 0, y: 0, width: size.width, height: size.height)
	}


	public init(left: CGFloat, top: CGFloat, width: CGFloat, height: CGFloat) {
		self.init(x: left, y: top, width: width, height: height)
	}


	public init(width: CGFloat, height: CGFloat) {
		self.init(x: 0, y: 0, width: width, height: height)
	}


	public var bottom: CGFloat {
		get { return origin.top + size.height }
		mutating set { origin.top = newValue - size.height }
	}


	public var bottomLeft: CGPoint {
		get { return CGPoint(left: left, top: bottom) }
		mutating set { left = newValue.left; bottom = newValue.top }
	}


	public var bottomRight: CGPoint {
		get { return CGPoint(left: right, top: bottom) }
		mutating set { right = newValue.left; bottom = newValue.top }
	}


	public var center: CGPoint {
		get { return CGPoint(left: left + (width / 2), top: top + (height / 2)) }
		mutating set { left = newValue.left - (width / 2); top = newValue.top - (height / 2) }
	}


	@warn_unused_result
	public func containsPoint(point: CGPoint) -> Bool {
		return containsPoint(point, atCornerRadius: 0)
	}


	@warn_unused_result
	public func containsPoint(point: CGPoint, atCornerRadius cornerRadius: CGFloat) -> Bool {
		if (!CGRectContainsPoint(self, point)) {
			// full rect misses, so does any rounded rect
			return false
		}

		if cornerRadius <= 0 {
			// full rect already hit
			return true
		}

		// we already hit the full rect, so if the point is at least cornerRadius pixels away from both sides in one axis we have a hit

		let minX = origin.x
		let minXAfterCorner = minX + cornerRadius
		let maxX = minX + width
		let maxXBeforeCorner = maxX - cornerRadius

		if point.x >= minXAfterCorner && point.x <= maxXBeforeCorner {
			return true
		}

		let minY = origin.y
		let minYAfterCorner = minY + cornerRadius
		let maxY = minY + height
		let maxYBeforeCorner = maxY - cornerRadius

		if point.y >= minYAfterCorner && point.y <= maxYBeforeCorner {
			return true
		}

		// it must be near one of the corners - figure out which one

		let midX = minX + (width / 2)
		let midY = minY + (height / 2)
		let circleCenter: CGPoint

		if point.x <= midX {  // must be near one of the left corners
			if point.y <= midY {  // must be near the top left corner
				circleCenter = CGPoint(x: minXAfterCorner, y: minYAfterCorner)
			}
			else {  // must be near the bottom left corner
				circleCenter = CGPoint(x: minXAfterCorner, y: maxYBeforeCorner)
			}
		}
		else {  // must ne near one of the right corners
			if point.y <= midY {  // must be near the top right corner
				circleCenter = CGPoint(x: maxXBeforeCorner, y: minYAfterCorner)
			}
			else {  // must be near the bottom right corner
				circleCenter = CGPoint(x: maxXBeforeCorner, y: maxYBeforeCorner)
			}
		}

		// just test distance from the matching circle to the point
		return (circleCenter.distanceTo(point) <= cornerRadius)
	}


	internal var height: CGFloat {  // make public once the ambigous call problem is solved
		get { return size.height }
		mutating set { size.height = newValue }
	}


	public var horizontalCenter: CGFloat {
		get { return CGFloat(left + (width / 2)) }
		mutating set { left = newValue - (width / 2) }
	}


	public var left: CGFloat {
		get { return origin.left }
		mutating set { origin.left = newValue }
	}


	public var right: CGFloat {
		get { return origin.left + size.width }
		mutating set { origin.left = newValue - size.width }
	}


	public var top: CGFloat {
		get { return origin.top }
		mutating set { origin.top = newValue }
	}


	public var topLeft: CGPoint {
		get { return origin }
		mutating set { origin = newValue }
	}


	public var topRight: CGPoint {
		get { return CGPoint(left: right, top: top) }
		mutating set { right = newValue.left; top = newValue.top }
	}


	@warn_unused_result(mutable_variant="transformInPlace")
	public func transform(transform: CGAffineTransform) -> CGRect {
		return CGRectApplyAffineTransform(self, transform)
	}


	public mutating func transformInPlace(transform: CGAffineTransform) {
		self = self.transform(transform)
	}


	public var verticalCenter: CGFloat {
		get { return CGFloat(top + (height / 2)) }
		mutating set { top = newValue - (height / 2) }
	}


	internal var width: CGFloat {  // make public once the ambigous call problem is solved
		get { return size.width }
		mutating set { size.width = newValue }
	}
}

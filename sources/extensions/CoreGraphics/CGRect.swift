import CoreGraphics


extension CGRect {

	init(size: CGSize) {
		self.init(x: 0, y: 0, width: size.width, height: size.height)
	}

	init(width: CGFloat, height: CGFloat) {
		self.init(x: 0, y: 0, width: width, height: height)
	}

	var bottom: CGFloat {
		get { return origin.y + size.height }
		mutating set { origin.y = newValue - size.height }
	}

	var bottomLeft: CGPoint {
		get { return CGPoint(x: left, y: bottom) }
		mutating set { left = newValue.x; bottom = newValue.y }
	}

	var bottomRight: CGPoint {
		get { return CGPoint(x: right, y: bottom) }
		mutating set { right = newValue.x; bottom = newValue.y }
	}

	var center: CGPoint {
		get { return CGPoint(x: left + (width / 2), y: top + (height / 2)) }
		mutating set { left = newValue.x - (width / 2); top = newValue.y - (height / 2) }
	}

	var height: CGFloat {
		get { return size.height }
		mutating set { size.height = newValue }
	}

	var left: CGFloat {
		get { return origin.x }
		mutating set { origin.x = newValue }
	}

	var right: CGFloat {
		get { return origin.x + size.width }
		mutating set { origin.x = newValue - size.width }
	}

	var top: CGFloat {
		get { return origin.y }
		mutating set { origin.y = newValue }
	}

	var topLeft: CGPoint {
		get { return origin }
		mutating set { origin = newValue }
	}

	var topRight: CGPoint {
		get { return CGPoint(x: right, y: top) }
		mutating set { right = newValue.x; top = newValue.y }
	}

	var width: CGFloat {
		get { return size.width }
		mutating set { size.width = newValue }
	}
}

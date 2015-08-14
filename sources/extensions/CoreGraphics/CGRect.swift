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

	var height: CGFloat {  // make public once the ambigous call problem is solved
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

	public var verticalCenter: CGFloat {
		get { return CGFloat(top + (height / 2)) }
		mutating set { top = newValue - (height / 2) }
	}

	var width: CGFloat {  // make public once the ambigous call problem is solved
		get { return size.width }
		mutating set { size.width = newValue }
	}
}

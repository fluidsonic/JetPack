import CoreGraphics


public struct CornerRadii: Equatable {

	public static let zero = CornerRadii()

	public var bottomLeft: CGFloat
	public var bottomRight: CGFloat
	public var topLeft: CGFloat
	public var topRight: CGFloat


	public init(all: CGFloat) {
		self.init(topLeft: all, topRight: all, bottomRight: all, bottomLeft: all)
	}


	public init(bottom: CGFloat) {
		self.init(top: 0, bottom: bottom)
	}


	public init(left: CGFloat) {
		self.init(left: left, right: 0)
	}


	public init(left: CGFloat, right: CGFloat) {
		self.init(topLeft: left, topRight: right, bottomRight: right, bottomLeft: left)
	}


	public init(right: CGFloat) {
		self.init(left: 0, right: right)
	}


	public init(top: CGFloat) {
		self.init(top: top, bottom: 0)
	}


	public init(top: CGFloat, bottom: CGFloat) {
		self.init(topLeft: top, topRight: top, bottomRight: bottom, bottomLeft: bottom)
	}


	public init(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomRight: CGFloat = 0, bottomLeft: CGFloat = 0) {
		self.bottomLeft = bottomLeft
		self.bottomRight = bottomRight
		self.topLeft = topLeft
		self.topRight = topRight
	}


	public var isZero: Bool {
		return bottomLeft == 0 && bottomRight == 0 && topLeft == 0 && topRight == 0
	}
}

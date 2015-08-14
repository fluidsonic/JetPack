import CoreGraphics


public extension CGSize {

	public static let maxSize = CGSize(width: CGFloat.max, height: CGFloat.max)


	public init(square length: CGFloat) {
		self.init(width: length, height: length)
	}


	public var center: CGPoint {
		return CGPoint(x: width / 2, y: height / 2)
	}


	public var isEmpty: Bool {
		return (height == 0 || width == 0)
	}


	public func sizeConstrainedToSize(constrain: CGSize) -> CGSize {
		return CGSize(width: min(width, constrain.width), height: min(height, constrain.height))
	}
}

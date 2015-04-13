import CoreGraphics


public extension CGSize {

	public static let maxSize = CGSize(width: CGFloat.max, height: CGFloat.max)


	public var center: CGPoint {
		return CGPoint(x: width / 2, y: height / 2)
	}


	public var isEmpty: Bool {
		return (height == 0 || width == 0)
	}
}

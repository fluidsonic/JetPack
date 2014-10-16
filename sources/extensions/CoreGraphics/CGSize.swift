import CoreGraphics


extension CGSize {

	static let maxSize = CGSize(width: CGFloat.max, height: CGFloat.max)


	var center: CGPoint {
		return CGPoint(x: width / 2, y: width / 2)
	}
}

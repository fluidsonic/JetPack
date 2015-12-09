import CoreGraphics


public extension CGAffineTransform {

	public static let identity = CGAffineTransformIdentity


	public init(horizontalScale: CGFloat, verticalScale: CGFloat = 1) {
		self = CGAffineTransformMakeScale(horizontalScale, verticalScale)
	}


	public init(verticalScale: CGFloat) {
		self = CGAffineTransformMakeScale(1, verticalScale)
	}


	public init(horizontalTranslation: CGFloat, verticalTranslation: CGFloat = 1) {
		self = CGAffineTransformMakeTranslation(horizontalTranslation, verticalTranslation)
	}


	public init(verticalTranslation: CGFloat) {
		self = CGAffineTransformMakeTranslation(0, verticalTranslation)
	}


	public init(rotation angle: CGFloat) {
		self = CGAffineTransformMakeRotation(angle)
	}


	public init(scale: CGFloat) {
		self = CGAffineTransformMakeScale(scale, scale)
	}


	public mutating func rotateBy(angle: CGFloat) {
		self = rotatedBy(angle)
	}


	@warn_unused_result(mutable_variant="rotateBy")
	public func rotatedBy(angle: CGFloat) -> CGAffineTransform {
		return CGAffineTransformRotate(self, angle)
	}


	public mutating func scaleBy(scale: CGFloat) {
		scaleBy(horizontally: scale, vertically: scale)
	}


	public mutating func scaleBy(horizontally horizontal: CGFloat, vertically vertical: CGFloat = 1) {
		self = scaledBy(horizontally: horizontal, vertically: vertical)
	}


	public mutating func scaleBy(vertically vertical: CGFloat) {
		scaleBy(horizontally: 1, vertically: vertical)
	}


	@warn_unused_result(mutable_variant="scaleBy")
	public func scaledBy(scale: CGFloat) -> CGAffineTransform {
		return scaledBy(horizontally: scale, vertically: scale)
	}


	@warn_unused_result(mutable_variant="scaleBy")
	public func scaledBy(horizontally horizontal: CGFloat, vertically vertical: CGFloat = 1) -> CGAffineTransform {
		return CGAffineTransformScale(self, horizontal, vertical)
	}


	@warn_unused_result(mutable_variant="scaleBy")
	public func scaledBy(vertically vertical: CGFloat) -> CGAffineTransform {
		return scaledBy(horizontally: 1, vertically: vertical)
	}


	public mutating func translateBy(horizontally horizontal: CGFloat, vertically vertical: CGFloat = 0) {
		self = translatedBy(horizontally: horizontal, vertically: vertical)
	}


	public mutating func translateBy(vertically vertical: CGFloat) {
		translateBy(horizontally: 0, vertically: vertical)
	}


	@warn_unused_result(mutable_variant="translateBy")
	public func translatedBy(horizontally horizontal: CGFloat, vertically vertical: CGFloat = 0) -> CGAffineTransform {
		return CGAffineTransformTranslate(self, horizontal, vertical)
	}


	@warn_unused_result(mutable_variant="translateBy")
	public func translatedBy(vertically vertical: CGFloat) -> CGAffineTransform {
		return translatedBy(horizontally: 0, vertically: vertical)
	}
}


extension CGAffineTransform: Equatable {}


public func == (a: CGAffineTransform, b: CGAffineTransform) -> Bool {
	return CGAffineTransformEqualToTransform(a, b)
}

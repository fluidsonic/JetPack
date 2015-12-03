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


	public mutating func rotate(angle: CGFloat) {
		self = rotated(angle)
	}


	@warn_unused_result(mutable_variant="rotate")
	public func rotated(angle: CGFloat) -> CGAffineTransform {
		return CGAffineTransformRotate(self, angle)
	}


	public mutating func scale(horizontally horizontal: CGFloat, vertically vertical: CGFloat = 1) {
		self = scaled(horizontally: horizontal, vertically: vertical)
	}


	public mutating func scale(vertically vertical: CGFloat) {
		scale(horizontally: 1, vertically: vertical)
	}


	@warn_unused_result(mutable_variant="scale")
	public func scaled(horizontally horizontal: CGFloat, vertically vertical: CGFloat = 1) -> CGAffineTransform {
		return CGAffineTransformScale(self, horizontal, vertical)
	}


	@warn_unused_result(mutable_variant="scale")
	public func scaled(vertically vertical: CGFloat) -> CGAffineTransform {
		return scaled(horizontally: 1, vertically: vertical)
	}


	public mutating func translate(horizontally horizontal: CGFloat, vertically vertical: CGFloat = 0) {
		self = translated(horizontally: horizontal, vertically: vertical)
	}


	public mutating func translate(vertically vertical: CGFloat) {
		translate(horizontally: 0, vertically: vertical)
	}


	@warn_unused_result(mutable_variant="translate")
	public func translated(horizontally horizontal: CGFloat, vertically vertical: CGFloat = 0) -> CGAffineTransform {
		return CGAffineTransformTranslate(self, horizontal, vertical)
	}


	@warn_unused_result(mutable_variant="translate")
	public func translated(vertically vertical: CGFloat) -> CGAffineTransform {
		return translated(horizontally: 0, vertically: vertical)
	}
}

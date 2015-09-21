import CoreGraphics


public extension CGSize {

	public static let max = CGSize(square: .max)


	public init(square length: CGFloat) {
		self.init(width: length, height: length)
	}


	public var center: CGPoint {
		return CGPoint(x: width / 2, y: height / 2)
	}


	public mutating func constrainInPlace(constrain: CGSize) {
		self = constrainTo(constrain)
	}


	@warn_unused_result(mutable_variant="constrainInPlace")
	public func constrainTo(constrain: CGSize) -> CGSize {
		return CGSize(width: min(width, constrain.width), height: min(height, constrain.height))
	}


	public var isEmpty: Bool {
		return (height == 0 || width == 0)
	}


	@warn_unused_result(mutable_variant="scaleInPlace")
	public func scaleBy(scale: CGFloat) -> CGSize {
		return CGSize(width: width * scale, height: height * scale)
	}


	public mutating func scaleInPlace(scale: CGFloat) {
		self = scaleBy(scale)
	}


	@warn_unused_result(mutable_variant="transformInPlace")
	public func transform(transform: CGAffineTransform) -> CGSize {
		return CGSizeApplyAffineTransform(self, transform)
	}


	public mutating func transformInPlace(transform: CGAffineTransform) {
		self = self.transform(transform)
	}
}

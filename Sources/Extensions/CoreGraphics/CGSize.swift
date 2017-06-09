import CoreGraphics


public extension CGSize {

	public static let max = CGSize(square: .greatestFiniteMagnitude)


	public init(square length: CGFloat) {
		self.init(width: length, height: length)
	}


	public var absolute: CGSize {
		return CGSize(width: width.absolute, height: height.absolute)
	}


	public var center: CGPoint {
		return CGPoint(x: width / 2, y: height / 2)
	}


	public func coerced(atLeast minimum: CGSize) -> CGSize {
		return CGSize(
			width:  width.coerced(atLeast: minimum.width),
			height: height.coerced(atLeast: minimum.height)
		)
	}


	public func coerced(atMost maximum: CGSize) -> CGSize {
		return CGSize(
			width:  width.coerced(atMost: maximum.width),
			height: height.coerced(atMost: maximum.height)
		)
	}


	public func coerced(atLeast minimum: CGSize, atMost maximum: CGSize) -> CGSize {
		return coerced(atMost: maximum).coerced(atLeast: minimum)
	}


	public mutating func constrainInPlace(_ constrain: CGSize) {
		self = coerced(atMost: constrain)
	}


	@available(*, deprecated: 1, renamed: "coerced(atMost:)")
	public func constrainTo(_ constrain: CGSize) -> CGSize {
		return coerced(atMost: constrain)
	}


	public var isEmpty: Bool {
		return (height == 0 || width == 0)
	}


	public var isPositive: Bool {
		return (height > 0 && width > 0)
	}


	public var isValid: Bool {
		return (height >= 0 && width >= 0)
	}

	
	public func scaleBy(_ scale: CGFloat) -> CGSize {
		return CGSize(width: width * scale, height: height * scale)
	}


	public mutating func scaleInPlace(_ scale: CGFloat) {
		self = scaleBy(scale)
	}


	public func transform(_ transform: CGAffineTransform) -> CGSize {
		return self.applying(transform)
	}


	public mutating func transformInPlace(_ transform: CGAffineTransform) {
		self = self.transform(transform)
	}
}

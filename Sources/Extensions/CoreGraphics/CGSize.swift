import CoreGraphics


public extension CGSize {

	static let max = CGSize(square: .greatestFiniteMagnitude)


	init(square length: CGFloat) {
		self.init(width: length, height: length)
	}


	var absolute: CGSize {
		return CGSize(width: width.absolute, height: height.absolute)
	}


	var center: CGPoint {
		return CGPoint(x: width / 2, y: height / 2)
	}


	func coerced(atLeast minimum: CGSize) -> CGSize {
		return CGSize(
			width:  width.coerced(atLeast: minimum.width),
			height: height.coerced(atLeast: minimum.height)
		)
	}


	func coerced(atMost maximum: CGSize) -> CGSize {
		return CGSize(
			width:  width.coerced(atMost: maximum.width),
			height: height.coerced(atMost: maximum.height)
		)
	}


	func coerced(atLeast minimum: CGSize, atMost maximum: CGSize) -> CGSize {
		return coerced(atMost: maximum).coerced(atLeast: minimum)
	}


	mutating func constrainInPlace(_ constrain: CGSize) {
		self = coerced(atMost: constrain)
	}


	@available(*, deprecated, renamed: "coerced(atMost:)")
	func constrainTo(_ constrain: CGSize) -> CGSize {
		return coerced(atMost: constrain)
	}


	var isEmpty: Bool {
		return (height == 0 || width == 0)
	}


	var isPositive: Bool {
		return (height > 0 && width > 0)
	}


	var isValid: Bool {
		return (height >= 0 && width >= 0)
	}

	
	func scaleBy(_ scale: CGFloat) -> CGSize {
		return CGSize(width: width * scale, height: height * scale)
	}


	mutating func scaleInPlace(_ scale: CGFloat) {
		self = scaleBy(scale)
	}


	func transform(_ transform: CGAffineTransform) -> CGSize {
		return self.applying(transform)
	}


	mutating func transformInPlace(_ transform: CGAffineTransform) {
		self = self.transform(transform)
	}
}

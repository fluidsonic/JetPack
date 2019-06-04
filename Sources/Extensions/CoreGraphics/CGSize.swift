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


	@available(*, deprecated, message: "size = size.coerced(atMost: …)")
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


	func scale(by scale: CGFloat) -> CGSize {
		return CGSize(width: width * scale, height: height * scale)
	}


	@available(*, unavailable, renamed: "scale(by:)")
	func scaleBy(_ scale: CGFloat) -> CGSize {
		return self.scale(by: scale)
	}


	@available(*, deprecated, message: "size = size.scale(by: …)")
	mutating func scaleInPlace(_ scale: CGFloat) {
		self = self.scale(by: scale)
	}


	@available(*, unavailable, renamed: "applying")
	func transform(_ transform: CGAffineTransform) -> CGSize {
		return applying(transform)
	}


	@available(*, deprecated, message: "size = size.applying(…)")
	mutating func transformInPlace(_ transform: CGAffineTransform) {
		self = applying(transform)
	}


	static prefix func - (_ size: CGSize) -> CGSize {
		return CGSize(width: -size.width, height: -size.height)
	}


	static func + (_ lhs: CGSize, _ rhs: CGSize) -> CGSize {
		return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
	}


	static func += (_ lhs: inout CGSize, _ rhs: CGSize) {
		lhs = lhs + rhs
	}


	static func - (_ lhs: CGSize, _ rhs: CGSize) -> CGSize {
		return CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
	}


	static func -= (_ lhs: inout CGSize, _ rhs: CGSize) {
		lhs = lhs - rhs
	}
}

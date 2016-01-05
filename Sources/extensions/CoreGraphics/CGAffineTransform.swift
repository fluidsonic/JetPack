import CoreGraphics


public extension CGAffineTransform {

	public static let identity = CGAffineTransformIdentity


	public init(horizontalScale: CGFloat, verticalScale: CGFloat = 1) {
		self = CGAffineTransformMakeScale(horizontalScale, verticalScale)
	}


	public init(verticalScale: CGFloat) {
		self = CGAffineTransformMakeScale(1, verticalScale)
	}


	public init(horizontalTranslation: CGFloat, verticalTranslation: CGFloat = 0) {
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


	public mutating func concatenateWith(transform: CGAffineTransform) {
		self = concatenatedWith(transform)
	}


	@warn_unused_result(mutable_variant="concatenateWith")
	public func concatenatedWith(transform: CGAffineTransform) -> CGAffineTransform {
		return CGAffineTransformConcat(self, transform)
	}


	public var horizontalScale: CGFloat {
		return sqrt((a * a) + (c * c))
	}


	public var horizontalTranslation: CGFloat {
		return tx
	}


	public mutating func inverse() {
		self = inverted()
	}


	@warn_unused_result(mutable_variant="invert")
	public func inverted() -> CGAffineTransform {
		return CGAffineTransformInvert(self)
	}


	public var isIdentity: Bool {
		return CGAffineTransformIsIdentity(self)
	}


	public var rotation: CGFloat {
		return atan2(b, a)
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


	public var verticalScale: CGFloat {
		return sqrt((b * b) + (d * d))
	}


	public var verticalTranslation: CGFloat {
		return ty
	}
}


extension CGAffineTransform: CustomStringConvertible {

	public var description: String {
		guard !isIdentity else {
			return "CGAffineTransform.identity"
		}

		let horizontalScale = self.horizontalScale
		let verticalScale = self.verticalScale
		let horizontalTranslation = self.horizontalTranslation
		let verticalTranslation = self.verticalTranslation
		let rotation = self.rotation

		var description = ""

		if horizontalScale != 1 {
			if !description.isEmpty { description += ", " }
			description += "horizontalScale: "
			description += String(horizontalScale)
		}

		if verticalScale != 1 {
			if !description.isEmpty { description += ", " }
			description += "verticalScale: "
			description += String(verticalScale)
		}

		if rotation != 0 {
			if !description.isEmpty { description += ", " }
			description += "rotation: "
			description += String(rotation / .Pi)
			description += " * .Pi"
		}

		if horizontalTranslation != 0 {
			if !description.isEmpty { description += ", " }
			description += "horizontalTranslation: "
			description += String(horizontalTranslation)
		}

		if verticalTranslation != 0 {
			if !description.isEmpty { description += ", " }
			description += "verticalTranslation: "
			description += String(verticalTranslation)
		}

		guard !description.isEmpty else {
			return "CGAffineTransform.identity"
		}

		return "CGAffineTransform(" + description + ")"
	}
}


extension CGAffineTransform: Equatable {}


public func == (a: CGAffineTransform, b: CGAffineTransform) -> Bool {
	return CGAffineTransformEqualToTransform(a, b)
}

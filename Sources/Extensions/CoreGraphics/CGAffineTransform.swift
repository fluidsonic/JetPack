import CoreGraphics


public extension CGAffineTransform {

	public init(horizontalScale: CGFloat, verticalScale: CGFloat = 1) {
		self = CGAffineTransform(scaleX: horizontalScale, y: verticalScale)
	}


	public init(verticalScale: CGFloat) {
		self = CGAffineTransform(scaleX: 1, y: verticalScale)
	}


	public init(horizontalTranslation: CGFloat, verticalTranslation: CGFloat = 0) {
		self = CGAffineTransform(translationX: horizontalTranslation, y: verticalTranslation)
	}


	public init(verticalTranslation: CGFloat) {
		self = CGAffineTransform(translationX: 0, y: verticalTranslation)
	}


	public init(rotation angle: CGFloat) {
		self = CGAffineTransform(rotationAngle: angle)
	}


	public init(scale: CGFloat) {
		self = CGAffineTransform(scaleX: scale, y: scale)
	}


	public var horizontalScale: CGFloat {
		return sqrt((a * a) + (c * c))
	}


	public var horizontalTranslation: CGFloat {
		return tx
	}


	public var rotation: CGFloat {
		return atan2(b, a)
	}


	public func scaledBy(_ scale: CGFloat) -> CGAffineTransform {
		return scaledBy(horizontally: scale, vertically: scale)
	}


	public func scaledBy(horizontally horizontal: CGFloat, vertically vertical: CGFloat = 1) -> CGAffineTransform {
		return scaledBy(x: horizontal, y: vertical)
	}


	public func scaledBy(vertically vertical: CGFloat) -> CGAffineTransform {
		return scaledBy(horizontally: 1, vertically: vertical)
	}


	public func translatedBy(horizontally horizontal: CGFloat, vertically vertical: CGFloat = 0) -> CGAffineTransform {
		return self.translatedBy(x: horizontal, y: vertical)
	}

	
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
			description += String(describing: horizontalScale)
		}

		if verticalScale != 1 {
			if !description.isEmpty { description += ", " }
			description += "verticalScale: "
			description += String(describing: verticalScale)
		}

		if rotation != 0 {
			if !description.isEmpty { description += ", " }
			description += "rotation: "
			description += String(describing: rotation / .pi)
			description += " * .pi"
		}

		if horizontalTranslation != 0 {
			if !description.isEmpty { description += ", " }
			description += "horizontalTranslation: "
			description += String(describing: horizontalTranslation)
		}

		if verticalTranslation != 0 {
			if !description.isEmpty { description += ", " }
			description += "verticalTranslation: "
			description += String(describing: verticalTranslation)
		}

		guard !description.isEmpty else {
			return "CGAffineTransform.identity"
		}

		return "CGAffineTransform(" + description + ")"
	}
}


public func * (a: CGAffineTransform, b: CGAffineTransform) -> CGAffineTransform {
	return a.concatenating(b)
}

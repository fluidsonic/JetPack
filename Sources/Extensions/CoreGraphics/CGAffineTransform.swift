import CoreGraphics


public extension CGAffineTransform {

	init(horizontalScale: CGFloat, verticalScale: CGFloat = 1) {
		self = CGAffineTransform(scaleX: horizontalScale, y: verticalScale)
	}


	init(verticalScale: CGFloat) {
		self = CGAffineTransform(scaleX: 1, y: verticalScale)
	}


	init(horizontalTranslation: CGFloat, verticalTranslation: CGFloat = 0) {
		self = CGAffineTransform(translationX: horizontalTranslation, y: verticalTranslation)
	}


	init(verticalTranslation: CGFloat) {
		self = CGAffineTransform(translationX: 0, y: verticalTranslation)
	}


	@available(*, unavailable, renamed: "init(rotationAngle:)")
	init(rotation angle: CGFloat) {
		self = CGAffineTransform(rotationAngle: angle)
	}


	init(scale: CGFloat) {
		self = CGAffineTransform(scaleX: scale, y: scale)
	}


	var horizontalScale: CGFloat {
		return sqrt((a * a) + (c * c))
	}


	var horizontalTranslation: CGFloat {
		return tx
	}


	@available(*, unavailable, renamed: "rotationAngle")
	var rotation: CGFloat {
		return atan2(b, a)
	}


	var rotationAngle: CGFloat {
		return atan2(b, a)
	}


	func scaledBy(_ scale: CGFloat) -> CGAffineTransform {
		return scaledBy(horizontally: scale, vertically: scale)
	}


	func scaledBy(horizontally horizontal: CGFloat, vertically vertical: CGFloat = 1) -> CGAffineTransform {
		return scaledBy(x: horizontal, y: vertical)
	}


	func scaledBy(vertically vertical: CGFloat) -> CGAffineTransform {
		return scaledBy(horizontally: 1, vertically: vertical)
	}


	func translatedBy(horizontally horizontal: CGFloat, vertically vertical: CGFloat = 0) -> CGAffineTransform {
		return self.translatedBy(x: horizontal, y: vertical)
	}

	
	func translatedBy(vertically vertical: CGFloat) -> CGAffineTransform {
		return translatedBy(horizontally: 0, vertically: vertical)
	}


	var verticalScale: CGFloat {
		return sqrt((b * b) + (d * d))
	}


	var verticalTranslation: CGFloat {
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
		let rotationAngle = self.rotationAngle

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

		if rotationAngle != 0 {
			if !description.isEmpty { description += ", " }
			description += "rotationAngle: "
			description += String(describing: rotationAngle / .pi)
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

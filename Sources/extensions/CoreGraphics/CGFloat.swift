import CoreGraphics


public extension CGFloat {

	public static let Epsilon = CGFloat(NativeType.Epsilon)
	public static let Pi = CGFloat(NativeType.Pi)


	public var rounded: CGFloat {
		return round(self)
	}


	public var roundedDown: CGFloat {
		return floor(self)
	}


	public var roundedUp: CGFloat {
		return ceil(self)
	}
}

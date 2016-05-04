import Darwin


public extension Double {

	public static let Epsilon = Double(DBL_EPSILON)
	public static let Pi = Double(M_PI)


	public var rounded: Double {
		return round(self)
	}


	public func roundedTo(increment: Double) -> Double {
		return round(self / increment) * increment
	}


	public var roundedDown: Double {
		return floor(self)
	}


	public var roundedUp: Double {
		return ceil(self)
	}
}

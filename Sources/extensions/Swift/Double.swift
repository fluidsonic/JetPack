import Darwin


public extension Double {

	public static let Epsilon = Double(DBL_EPSILON)
	public static let Pi = Double(M_PI)


	public var round: Double {
		return Darwin.round(self)
	}
}

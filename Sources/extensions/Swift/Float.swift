import Darwin


public extension Float {

	public static let Epsilon = Float(FLT_EPSILON)
	public static let Pi = Float(M_PI)


	public var round: Float {
		return Darwin.round(self)
	}
}

public extension Double {

	public func clamped(#min: Double, max: Double) -> Double {
		return Swift.min(Swift.max(self, min), max)
	}


	public static var Epsilon: Double {
		return 1.19209290e-07
	}
}

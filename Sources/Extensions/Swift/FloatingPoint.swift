public extension FloatingPoint {

	public func rounded(increment: Self) -> Self {
		return (self / increment).rounded() * increment
	}


	public func rounded(_ rule: FloatingPointRoundingRule, increment: Self) -> Self {
		return (self / increment).rounded(rule) * increment
	}
}

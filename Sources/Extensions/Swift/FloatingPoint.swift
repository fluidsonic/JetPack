public extension FloatingPoint {

	func rounded(increment: Self) -> Self {
		return (self / increment).rounded() * increment
	}


	func rounded(_ rule: FloatingPointRoundingRule, increment: Self) -> Self {
		return (self / increment).rounded(rule) * increment
	}
}

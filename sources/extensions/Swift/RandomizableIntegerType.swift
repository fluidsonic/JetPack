public protocol RandomizableIntegerType: IntegerType {

	@warn_unused_result
	static func random(start start: Self, end: Self) -> Self
}


public extension RandomizableIntegerType {

	@warn_unused_result
	public static func random(min min: Self = 0, max: Self) -> Self {
		return random(start: min, end: max + 1)
	}
}

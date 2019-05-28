public protocol RandomizableIntegerType: FixedWidthInteger {

	
	static func random(start: Self, end: Self) -> Self
}


public extension RandomizableIntegerType {

	
	static func random(min: Self = 0, max: Self) -> Self {
		return random(start: min, end: max + 1)
	}
}

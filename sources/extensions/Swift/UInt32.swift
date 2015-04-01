public extension UInt32 {

	public static func random(lower: UInt32 = min, upper: UInt32 = max) -> UInt32 {
		return arc4random_uniform(upper - lower) + lower
	}


	public static func random(min: UInt32 = 0, max: UInt32) -> UInt32 {
		return random(lower: min, upper: max + 1)
	}


	public static func random(range: Range<UInt32>) -> UInt32 {
		return random(min: range.startIndex, max: range.endIndex)
	}
}

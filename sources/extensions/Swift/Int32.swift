public extension Int32 {

	public static func random(lower lower: Int32 = min, upper: Int32 = max) -> Int32 {
		let r = arc4random_uniform(UInt32(Int64(upper) - Int64(lower)))
		return Int32(Int64(r) + Int64(lower))
	}


	public static func random(min min: Int32 = 0, max: Int32) -> Int32 {
		return random(lower: min, upper: max + 1)
	}


	public static func random(range: Range<Int32>) -> Int32 {
		return random(min: range.startIndex, max: range.endIndex)
	}
}

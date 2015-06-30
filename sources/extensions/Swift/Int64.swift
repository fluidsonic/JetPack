public extension Int64 {

	public static func random(lower lower: Int64 = min, upper: Int64 = max) -> Int64 {
		let (s, overflow) = Int64.subtractWithOverflow(upper, lower)
		let u = overflow ? UInt64.max - UInt64(~s) : UInt64(s)
		let r = UInt64.random(upper: u)

		if r > UInt64(Int64.max)  {
			return Int64(r - (UInt64(~lower) + 1))
		}

		return Int64(r) + lower
	}


	public static func random(min min: Int64 = 0, max: Int64) -> Int64 {
		return random(lower: min, upper: max + 1)
	}


	public static func random(range: Range<Int64>) -> Int64 {
		return random(min: range.startIndex, max: range.endIndex)
	}
}

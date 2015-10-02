extension Int64: RandomizableIntegerType {

	@warn_unused_result
	public static func random(start start: Int64, end: Int64) -> Int64 {
		let (s, overflow) = Int64.subtractWithOverflow(end, start)
		let u = overflow ? UInt64.max - UInt64(~s) : UInt64(s)
		let r = UInt64.random(start: .min, end: u)

		if r > UInt64(Int64.max)  {
			return Int64(r - (UInt64(~start) + 1))
		}

		return Int64(r) + start
	}
}

extension Int64: RandomizableIntegerType {

	public static func random(start: Int64, end: Int64) -> Int64 {
		precondition(start <= end)

		guard start != end else {
			return start
		}

		let (s, overflow) = end.subtractingReportingOverflow(start)
		let u = overflow == .overflow ? UInt64.max - UInt64(~s) : UInt64(s)
		let r = UInt64.random(start: .min, end: u)

		if r > UInt64(Int64.max)  {
			return Int64(r - (UInt64(~start) + 1))
		}

		return Int64(r) + start
	}
}

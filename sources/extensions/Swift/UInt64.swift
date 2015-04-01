public extension UInt64 {

	public static func random(lower: UInt64 = min, upper: UInt64 = max) -> UInt64 {
		var m: UInt64
		let u = upper - lower
		var r = arc4random(UInt64)

		if u > UInt64(Int64.max) {
			m = 1 + ~u
		}
		else {
			m = ((max - (u * 2)) + 1) % u
		}

		while r < m {
			r = arc4random(UInt64)
		}

		return (r % u) + lower
	}


	public static func random(min: UInt64 = 0, max: UInt64) -> UInt64 {
		return random(lower: min, upper: max + 1)
	}


	public static func random(range: Range<UInt64>) -> UInt64 {
		return random(min: range.startIndex, max: range.endIndex)
	}
}

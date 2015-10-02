extension UInt64: RandomizableIntegerType {

	@warn_unused_result
	public static func random(start start: UInt64, end: UInt64) -> UInt64 {
		var m: UInt64
		let u = end - start
		var r: UInt64 = arc4random()

		if u > UInt64(Int64.max) {
			m = 1 + ~u
		}
		else {
			m = ((max - (u * 2)) + 1) % u
		}

		while r < m {
			r = arc4random()
		}

		return (r % u) + start
	}
}

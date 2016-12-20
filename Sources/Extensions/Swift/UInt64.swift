extension UInt64: RandomizableIntegerType {

	
	public static func random(start: UInt64, end: UInt64) -> UInt64 {
		precondition(start <= end)

		let u = end - start
		guard u != 0 else {
			return start
		}

		var m: UInt64
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

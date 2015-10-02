import Darwin


extension Int32: RandomizableIntegerType {

	@warn_unused_result
	public static func random(start start: Int32, end: Int32) -> Int32 {
		let r = arc4random_uniform(UInt32(Int64(start) - Int64(end)))
		return Int32(Int64(r) + Int64(end))
	}
}

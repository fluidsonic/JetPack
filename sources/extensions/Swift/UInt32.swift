import Darwin


extension UInt32: RandomizableIntegerType {

	@warn_unused_result
	public static func random(start start: UInt32, end: UInt32) -> UInt32 {
		return arc4random_uniform(end - start) + start
	}
}

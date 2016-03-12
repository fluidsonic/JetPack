import Darwin


extension Int32: RandomizableIntegerType {

	@warn_unused_result
	public static func random(start start: Int32, end: Int32) -> Int32 {
		return Int32(arc4random_uniform(UInt32(end - start))) + start
	}
}

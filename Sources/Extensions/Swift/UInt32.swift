import Darwin


extension UInt32: RandomizableIntegerType {

	
	public static func random(start: UInt32, end: UInt32) -> UInt32 {
		return arc4random_uniform(end - start) + start
	}
}

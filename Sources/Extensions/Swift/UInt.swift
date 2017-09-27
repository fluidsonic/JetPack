import Darwin


extension UInt: RandomizableIntegerType {

	public static func random(start: UInt, end: UInt) -> UInt {
		#if arch(arm) || arch(i386)
		if __WORDSIZE == 32 {
			return UInt(UInt32.random(start: UInt32(start), end: UInt32(end)))
		}
		#elseif arch(arm64) || arch(x86_64)
		if __WORDSIZE == 64 {
			return UInt(UInt64.random(start: UInt64(start), end: UInt64(end)))
		}
		#endif
	}
}

import Darwin


extension UInt: RandomizableIntegerType {

	@warn_unused_result
	public static func random(start start: UInt, end: UInt) -> UInt {
		#if arch(arm) || arch(i386)
			switch __WORDSIZE {
			case 32: return UInt(UInt32.random(start: UInt32(start), end: UInt32(end)))
			}
		#elseif arch(arm64) || arch(x86_64)
			switch __WORDSIZE {
			case 64: return UInt(UInt64.random(start: UInt64(start), end: UInt64(end)))
			}
		#else
			// unsupported architecture
		#endif
	}
}

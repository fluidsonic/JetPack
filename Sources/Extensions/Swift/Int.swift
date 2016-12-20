import Darwin


extension Int: RandomizableIntegerType {

	
	public static func random(start: Int, end: Int) -> Int {
		#if arch(arm) || arch(i386)
			switch __WORDSIZE {
			case 32: return Int(Int32.random(start: Int32(start), end: Int32(end)))
			}
		#elseif arch(arm64) || arch(x86_64)
			switch __WORDSIZE {
			case 64: return Int(Int64.random(start: Int64(start), end: Int64(end)))
			}
		#else
			// unsupported architecture
		#endif
	}
}

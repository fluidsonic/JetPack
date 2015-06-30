public extension Int {

	public func clamped(min min: Int, max: Int) -> Int {
		return Swift.min(Swift.max(self, min), max)
	}


	public static func random(lower lower: Int = min, upper: Int = max) -> Int {
		#if arch(arm) || arch(i386)
			switch __WORDSIZE {
			case 32: return Int(Int32.random(lower: Int32(lower), upper: Int32(upper)))
			}
		#elseif arch(arm64) || arch(x86_64)
			switch __WORDSIZE {
			case 64: return Int(Int64.random(lower: Int64(lower), upper: Int64(upper)))
			}
		#else
			// unsupported architecture
		#endif
	}


	public static func random(min min: Int = 0, max: Int) -> Int {
		return random(lower: min, upper: max + 1)
	}


	public static func random(range: Range<Int>) -> Int {
		return random(min: range.startIndex, max: range.endIndex)
	}
}

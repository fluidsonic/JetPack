public extension UInt {

	public func clamped(min min: UInt, max: UInt) -> UInt {
		return Swift.min(Swift.max(self, min), max)
	}


	public static func random(lower lower: UInt = min, upper: UInt = max) -> UInt {
		#if arch(arm) || arch(i386)
			switch __WORDSIZE {
			case 32: return UInt(UInt32.random(lower: UInt32(lower), upper: UInt32(upper)))
			}
		#elseif arch(arm64) || arch(x86_64)
			switch __WORDSIZE {
			case 64: return UInt(UInt64.random(lower: UInt64(lower), upper: UInt64(upper)))
			}
		#else
			// unsupported architecture
		#endif
	}


	public static func random(min min: UInt = 0, max: UInt) -> UInt {
		return random(lower: min, upper: max + 1)
	}


	public static func random(range: Range<UInt>) -> UInt {
		return random(min: range.startIndex, max: range.endIndex)
	}
}

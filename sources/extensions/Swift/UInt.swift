public extension UInt {

	public func clamped(#min: UInt, max: UInt) -> UInt {
		return Swift.min(Swift.max(self, min), max)
	}


	public static func random(lower: UInt = min, upper: UInt = max) -> UInt {
		switch __WORDSIZE {
		case 32: return UInt(UInt32.random(lower: UInt32(lower), upper: UInt32(upper)))
		case 64: return UInt(UInt64.random(lower: UInt64(lower), upper: UInt64(upper)))
		default: fatalError("Unexpected __WORDSIZE: \(__WORDSIZE)")
		}
	}


	public static func random(min: UInt = 0, max: UInt) -> UInt {
		return random(lower: min, upper: max + 1)
	}


	public static func random(range: Range<UInt>) -> UInt {
		return random(min: range.startIndex, max: range.endIndex)
	}
}

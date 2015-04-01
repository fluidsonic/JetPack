public extension Int {

	public func clamped(#min: Int, max: Int) -> Int {
		return Swift.min(Swift.max(self, min), max)
	}


	public static func random(lower: Int = min, upper: Int = max) -> Int {
		switch __WORDSIZE {
		case 32: return Int(Int32.random(lower: Int32(lower), upper: Int32(upper)))
		case 64: return Int(Int64.random(lower: Int64(lower), upper: Int64(upper)))
		default: fatalError("Unexpected __WORDSIZE: \(__WORDSIZE)")
		}
	}


	public static func random(min: Int = 0, max: Int) -> Int {
		return random(lower: min, upper: max + 1)
	}


	public static func random(range: Range<Int>) -> Int {
		return random(min: range.startIndex, max: range.endIndex)
	}
}

import Darwin


extension UInt: RandomizableIntegerType {

	public static func random(start: UInt, end: UInt) -> UInt {
		switch __WORDSIZE {
		case 32: return UInt(UInt32.random(start: UInt32(start), end: UInt32(end)))
		case 64: return UInt(UInt64.random(start: UInt64(start), end: UInt64(end)))
		default: preconditionFailure("Unsupported architecture") // TODO would be great if we can catch this at compile-time
		}
	}
}

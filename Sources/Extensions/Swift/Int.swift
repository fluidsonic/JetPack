import Darwin


extension Int: RandomizableIntegerType {

	public static func random(start: Int, end: Int) -> Int {
		switch __WORDSIZE {
		case 32: return Int(Int32.random(start: Int32(start), end: Int32(end)))
		case 64: return Int(Int64.random(start: Int64(start), end: Int64(end)))
		default: preconditionFailure("Unsupported architecture") // TODO would be great if we can catch this at compile-time
		}
	}
}

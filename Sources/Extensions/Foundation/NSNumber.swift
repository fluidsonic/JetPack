import Foundation


public extension NSNumber {

	@nonobjc
	public var isNegative: Bool {
		return self < 0
	}


	@nonobjc
	internal func modulo(divisor: Int) -> Int {
		if let decimal = self as? NSDecimalNumber {
			return decimal.modulo(NSDecimalNumber(long: divisor)).longValue
		}

		switch CFNumberGetType(self) {
		case .CGFloatType, .DoubleType, .Float32Type, .Float64Type, .FloatType:
			return Int(doubleValue % Double(divisor))

		default:
			if isNegative {
				return Int(longLongValue % Int64(divisor))
			}
			else {
				let remainder = Int(unsignedLongLongValue % UInt64(abs(divisor)))
				return divisor < 0 ? -remainder : remainder
			}
		}
	}
}


extension NSNumber: Comparable {}


public func < (a: NSNumber, b: NSNumber) -> Bool {
	return a.compare(b) == .OrderedAscending
}

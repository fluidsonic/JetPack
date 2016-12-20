import Foundation


public extension NSNumber {

	@nonobjc
	public var isNegative: Bool {
		return self < 0
	}


	@nonobjc
	internal func modulo(_ divisor: Int) -> Int {
		if let decimal = self as? NSDecimalNumber {
			return decimal.modulo(NSDecimalNumber(value: divisor)).intValue
		}

		switch CFNumberGetType(self) {
		case .cgFloatType, .doubleType, .float32Type, .float64Type, .floatType:
			return Int(doubleValue.truncatingRemainder(dividingBy: Double(divisor)))

		default:
			if isNegative {
				return Int(int64Value % Int64(divisor))
			}
			else {
				let remainder = Int(uint64Value % UInt64(abs(divisor)))
				return divisor < 0 ? -remainder : remainder
			}
		}
	}
}


extension NSNumber: Comparable {}


public func < (a: NSNumber, b: NSNumber) -> Bool {
	return a.compare(b) == .orderedAscending
}

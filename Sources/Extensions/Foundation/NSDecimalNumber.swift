import Foundation


public extension NSDecimalNumber {

	@nonobjc
	internal func modulo(divisor: NSDecimalNumber) -> NSDecimalNumber {
		let roundingMode: NSRoundingMode = (isNegative != divisor.isNegative) ? .RoundUp : .RoundDown
		let roundingHandler = NSDecimalNumberHandler(roundingMode: roundingMode, scale: 0, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
		let quotient = decimalNumberByDividingBy(divisor, withBehavior: roundingHandler)
		let subtract = quotient.decimalNumberByMultiplyingBy(divisor)
		let remainder = decimalNumberBySubtracting(subtract)

		return divisor.isNegative ? remainder.negate() : remainder
	}


	@nonobjc
	public static let minusOne = NSDecimalNumber(mantissa: 1, exponent: 0, isNegative: true)


	@nonobjc
	internal func negate() -> NSDecimalNumber {
		return decimalNumberByMultiplyingBy(.minusOne)
	}
}

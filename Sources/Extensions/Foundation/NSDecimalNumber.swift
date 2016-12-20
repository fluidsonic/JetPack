import Foundation


public extension NSDecimalNumber {

	@nonobjc
	internal func modulo(_ divisor: NSDecimalNumber) -> NSDecimalNumber {
		let roundingMode: NSDecimalNumber.RoundingMode = (isNegative != divisor.isNegative) ? .up : .down
		let roundingHandler = NSDecimalNumberHandler(roundingMode: roundingMode, scale: 0, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
		let quotient = dividing(by: divisor, withBehavior: roundingHandler)
		let subtract = quotient.multiplying(by: divisor)
		let remainder = subtracting(subtract)

		return divisor.isNegative ? remainder.negate() : remainder
	}


	@nonobjc
	public static let minusOne = NSDecimalNumber(mantissa: 1, exponent: 0, isNegative: true)


	@nonobjc
	internal func negate() -> NSDecimalNumber {
		return multiplying(by: .minusOne)
	}
}

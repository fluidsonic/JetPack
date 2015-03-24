public protocol Measurement: Comparable, DebugPrintable, Hashable, Printable {

	typealias UnitType


	init(rawValue: Double)

	static var name: String { get }
	static var rawUnit: UnitType { get }
	var rawValue: Double { get mutating set }

	func valueInUnit(unit: UnitType) -> Double
}


public prefix func + <M: Measurement>(measurement: M) -> M {
	return measurement
}


public prefix func - <M: Measurement>(measurement: M) -> M {
	return M(rawValue: -measurement.rawValue)
}


public func + <M: Measurement>(a: M, b: M) -> M {
	return M(rawValue: a.rawValue + b.rawValue)
}


public func += <M: Measurement>(inout a: M, b: M) {
	a.rawValue += b.rawValue
}


public func - <M: Measurement>(a: M, b: M) -> M {
	return M(rawValue: a.rawValue - b.rawValue)
}


public func -= <M: Measurement>(inout a: M, b: M) {
	a.rawValue -= b.rawValue
}


public func * <M: Measurement>(a: M, b: M) -> M {
	return M(rawValue: a.rawValue * b.rawValue)
}


public func *= <M: Measurement>(inout a: M, b: M) {
	a.rawValue *= b.rawValue
}


public func / <M: Measurement>(a: M, b: M) -> M {
	return M(rawValue: a.rawValue / b.rawValue)
}


public func /= <M: Measurement>(inout a: M, b: M) {
	a.rawValue /= b.rawValue
}


public func % <M: Measurement>(a: M, b: M) -> M {
	return M(rawValue: a.rawValue % b.rawValue)
}


public func %= <M: Measurement>(inout a: M, b: M) {
	a.rawValue %= b.rawValue
}


public func == <M: Measurement>(a: M, b: M) -> Bool {
	return (a.rawValue == b.rawValue)
}


public func < <M: Measurement>(a: M, b: M) -> Bool {
	return (a.rawValue < b.rawValue)
}

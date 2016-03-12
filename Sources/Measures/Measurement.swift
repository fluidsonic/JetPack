public protocol Measure: Comparable, CustomDebugStringConvertible, Hashable, CustomStringConvertible {

	typealias UnitType


	init(rawValue: Double)
	init(_ value: Double, unit: UnitType)

	static var name: String { get }
	static var rawUnit: UnitType { get }
	var rawValue: Double { get mutating set }

	func valueInUnit(unit: UnitType) -> Double
}


public prefix func + <M: Measure>(measure: M) -> M {
	return measure
}


public prefix func - <M: Measure>(measure: M) -> M {
	return M(rawValue: -measure.rawValue)
}


public func + <M: Measure>(a: M, b: M) -> M {
	return M(rawValue: a.rawValue + b.rawValue)
}


public func += <M: Measure>(inout a: M, b: M) {
	a.rawValue += b.rawValue
}


public func - <M: Measure>(a: M, b: M) -> M {
	return M(rawValue: a.rawValue - b.rawValue)
}


public func -= <M: Measure>(inout a: M, b: M) {
	a.rawValue -= b.rawValue
}


public func * <M: Measure>(a: M, b: M) -> M {
	return M(rawValue: a.rawValue * b.rawValue)
}


public func *= <M: Measure>(inout a: M, b: M) {
	a.rawValue *= b.rawValue
}


public func / <M: Measure>(a: M, b: M) -> M {
	return M(rawValue: a.rawValue / b.rawValue)
}


public func /= <M: Measure>(inout a: M, b: M) {
	a.rawValue /= b.rawValue
}


public func % <M: Measure>(a: M, b: M) -> M {
	return M(rawValue: a.rawValue % b.rawValue)
}


public func %= <M: Measure>(inout a: M, b: M) {
	a.rawValue %= b.rawValue
}


public func == <M: Measure>(a: M, b: M) -> Bool {
	return (a.rawValue == b.rawValue)
}


public func < <M: Measure>(a: M, b: M) -> Bool {
	return (a.rawValue < b.rawValue)
}

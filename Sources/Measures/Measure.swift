public protocol Measure: Comparable, CustomDebugStringConvertible, CustomStringConvertible, Hashable {

	associatedtype UnitType: Unit


	init(rawValue: Double)
	init(_ value: Double, unit: UnitType)

	static var name: String { get }
	static var rawUnit: UnitType { get }
	var rawValue: Double { get mutating set }

	func valueInUnit(_ unit: UnitType) -> Double
}


public extension Measure { // CustomDebugStringConvertible

	var debugDescription: String {
		return "\(rawValue.description) \(Self.rawUnit.debugDescription)"
	}
}


public extension Measure { // CustomStringConvertible

	var description: String {
		return "\(rawValue.description) \(Self.rawUnit.abbreviation)"
	}
}


public extension Measure { // Hashable

	func hash(into hasher: inout Hasher) {
		hasher.combine(rawValue)
	}
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


public func += <M: Measure>(a: inout M, b: M) {
	a.rawValue += b.rawValue
}


public func - <M: Measure>(a: M, b: M) -> M {
	return M(rawValue: a.rawValue - b.rawValue)
}


public func -= <M: Measure>(a: inout M, b: M) {
	a.rawValue -= b.rawValue
}


public func * <M: Measure>(a: M, b: M) -> M {
	return M(rawValue: a.rawValue * b.rawValue)
}


public func *= <M: Measure>(a: inout M, b: M) {
	a.rawValue *= b.rawValue
}


public func / <M: Measure>(a: M, b: M) -> M {
	return M(rawValue: a.rawValue / b.rawValue)
}


public func /= <M: Measure>(a: inout M, b: M) {
	a.rawValue /= b.rawValue
}


public func % <M: Measure>(a: M, b: M) -> M {
	return M(rawValue: a.rawValue.truncatingRemainder(dividingBy: b.rawValue))
}


public func == <M: Measure>(a: M, b: M) -> Bool {
	return (a.rawValue == b.rawValue)
}


public func < <M: Measure>(a: M, b: M) -> Bool {
	return (a.rawValue < b.rawValue)
}

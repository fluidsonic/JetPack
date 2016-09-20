public protocol Measure: Comparable, CustomDebugStringConvertible, CustomStringConvertible, Hashable {

	associatedtype UnitType: Unit


	init(rawValue: Double)
	init(_ value: Double, unit: UnitType)

	static var name: String { get }
	static var rawUnit: UnitType { get }
	var rawValue: Double { get mutating set }

	func valueInUnit(unit: UnitType) -> Double
}


public extension Measure { // CustomDebugStringConvertible

	public var debugDescription: String {
		return "\(rawValue.description) \(Self.rawUnit.debugDescription)"
	}
}


public extension Measure { // CustomStringConvertible

	public var description: String {
		return "\(rawValue.description) \(Self.rawUnit.abbreviation)"
	}
}


public extension Measure { // Hashable

	public var hashValue: Int {
		return rawValue.hashValue
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

public protocol Unit: CustomDebugStringConvertible, CustomStringConvertible {

	var abbreviation: String { get }
	var name: PluralizedString { get }
	var symbol: String? { get }
}


public extension Unit { // CustomDebugStringConvertible

	public var debugDescription: String {
		return "\(type(of: self))(\(description))"
	}
}


public extension Unit { // CustomStringConvertible

	public var description: String {
		return name.forPluralCategory(.many)
	}
}

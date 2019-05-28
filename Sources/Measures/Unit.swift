public protocol Unit: CustomDebugStringConvertible, CustomStringConvertible {

	var abbreviation: String { get }
	var name: PluralizedString { get }
	var symbol: String? { get }
}


public extension Unit { // CustomDebugStringConvertible

	var debugDescription: String {
		return "\(type(of: self))(\(description))"
	}
}


public extension Unit { // CustomStringConvertible

	var description: String {
		return name.forPluralCategory(.many)
	}
}

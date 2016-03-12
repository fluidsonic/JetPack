public protocol Unit: CustomDebugStringConvertible, CustomStringConvertible {

	var abbreviation: String { get }
	var pluralName: String { get }
	var singularName: String { get }
	var symbol: String? { get }
}

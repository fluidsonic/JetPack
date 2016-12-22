public final class StrongReference<Value> {

	public var value: Value


	public init(_ value: Value) {
		self.value = value
	}
}


extension StrongReference: CustomDebugStringConvertible {

	public var debugDescription: String {
		return "StrongReference(\(String(reflecting: value)))"
	}
}


extension StrongReference: CustomStringConvertible {

	public var description: String {
		return String(describing: value)
	}
}

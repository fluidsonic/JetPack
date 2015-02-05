// Swift doesn't give us the name of Any.Type yet so we have to rely on NSStringFromClass :(

public struct AnyType {

	public let hashValue: Int
	public let name: String
	public let type: AnyClass


	public init(_ type: AnyClass) {
		self.name = NSStringFromClass(type)
		self.type = type

		hashValue = name.hashValue
	}


	public var demangledName: String {
		return _stdlib_getDemangledTypeName(type)
	}
}


extension AnyType: DebugPrintable {

	public var debugDescription: String {
		return name
	}
}


extension AnyType: Hashable {}


extension AnyType: Printable {

	public var description: String {
		return name
	}
}


public func == (a: AnyType, b: AnyType) -> Bool {
	return a.name == b.name
}

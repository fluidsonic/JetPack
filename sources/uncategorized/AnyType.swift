public struct AnyType {

	private let name: String
	private let type: Any


	public init(_ type: Any.Type) {
		self.name = _stdlib_getTypeName(type)
		self.type = type
	}


	public init(_ type: AnyObject.Type) {
		self.name = _stdlib_getTypeName(type)
		self.type = type
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


extension AnyType: Equatable {}


extension AnyType: Hashable {

	public var hashValue: Int {
		return name.hashValue
	}
}


extension AnyType: Printable {

	public var description: String {
		return demangledName
	}
}


public func == (a: AnyType, b: AnyType) -> Bool {
	return a.name == b.name
}

public struct Class {

	private let name: String
	private let type: AnyClass


	public init(_ type: AnyClass) {
		self.name = _stdlib_getTypeName(type)
		self.type = type
	}
}


extension Class: DebugPrintable {

	public var debugDescription: String {
		return description
	}
}


extension Class: Equatable {}


extension Class: Hashable {

	public var hashValue: Int {
		return name.hashValue
	}
}


extension Class: Printable {

	public var description: String {
		return name
	}
}


public func == (a: Class, b: Class) -> Bool {
	return a.type === b.type
}

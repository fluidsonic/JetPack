// AnyType temporarily moved to ObjectGraph.swift to prevent compiler crash in Swift 1.2 (Xcode 6.3 beta 1)
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
		return toString(type)
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




public class ObjectGraph {

	private var objects = [AnyType : AnyObject]()


	public init() {}


	public func add<T: AnyObject>(object: T) {
		objects[AnyType(T.self)] = object
	}


	public func get<T: AnyObject>() -> T {
		let typeWrapper = AnyType(T.self)
		if let object: AnyObject = objects[typeWrapper] {
			return object as! T
		}

		LOG("Cannot resolve graph object for type \(typeWrapper).")

		preconditionFailure()
	}
}


prefix operator << {}

public prefix func << <T: AnyObject>(graph: ObjectGraph) -> T {
	return graph.get()
}

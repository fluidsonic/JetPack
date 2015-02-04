import Foundation


public class ObjectGraph {

	private var objects = [AnyType : Any]()



	public init() {}


	public func add<T>(object: T) {
		objects[AnyType(T)] = object
	}


	public func get<T>() -> T {
		let typeWrapper = AnyType(T)
		if let object = objects[typeWrapper] {
			return object as T
		}

		preconditionFailure("Cannot resolve dependency for type \(typeWrapper).")
	}
}


prefix operator << {}

public prefix func << <T: AnyObject>(graph: ObjectGraph) -> T {
	return graph.get()
}

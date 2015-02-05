import Foundation


public class ObjectGraph {

	private var objects = [AnyType : AnyObject]()


	public init() {}


	public func add<T: AnyObject>(object: T) {
		objects[AnyType(T)] = object
	}


	public func get<T: AnyObject>() -> T {
		let typeWrapper = AnyType(T.self)
		if let object: AnyObject = objects[typeWrapper] {
			return object as T
		}

		LOG("Cannot resolve graph object for type \(typeWrapper).")

		preconditionFailure()
	}
}


prefix operator << {}

public prefix func << <T: AnyObject>(graph: ObjectGraph) -> T {
	return graph.get()
}

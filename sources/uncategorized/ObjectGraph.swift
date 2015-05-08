public class ObjectGraph {

	private var objects = [ObjectIdentifier : AnyObject]()


	public init() {}


	public func add<T: AnyObject>(object: T) {
		objects[ObjectIdentifier(T.Type)] = object
	}


	public func get<T: AnyObject>() -> T {
		let id = ObjectIdentifier(T.Type)
		if let object = objects[id] as! T? {
			return object
		}

		LOG("Cannot resolve graph object for type \(T.self).")

		preconditionFailure()
	}


	public func get<T: AnyObject>(type: T.Type) -> T {
		return get()
	}
}


prefix operator << {}

public prefix func << <T: AnyObject>(graph: ObjectGraph) -> T {
	return graph.get()
}

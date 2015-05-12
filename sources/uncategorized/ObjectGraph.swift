// TODO:


public class ObjectGraph {

	private var objects = [ObjectIdentifier : AnyObject]()


	public init() {}


	// You can only add AnyObject or else we'd have a big mess with (ImplicitlyUnwrapped)Optional which also conform to Any!
	public final func add<T: AnyObject>(object: T) {
		add(object, forType: T.self)
	}


	// You can only add AnyObject or else we'd have a big mess with (ImplicitlyUnwrapped)Optional which also conform to Any!
	public final func add<T: AnyObject>(object: T, forType type: T.Type) {
		let id = ObjectIdentifier(type as Any.Type)
		objects[id] = object
	}


	// You can only get AnyObject with implict type or else we'd have a big mess with (ImplicitlyUnwrapped)Optional which also conform to Any!
	public final func get<T: AnyObject>() -> T {
		return get(T.self)
	}


	// Getter must use Any although AnyObject would be more precise or else the compiler will crash when a class conforming protocol type is passed.
	public final func get<T: Any>(type: T.Type) -> T {
		let id = ObjectIdentifier(type)
		if let object = objects[id] as! T? {
			return object
		}

		LOG("Cannot resolve graph object for type \(type).")

		preconditionFailure()
	}
}


prefix operator << {}

public prefix func << <T: AnyObject>(graph: ObjectGraph) -> T {
	return graph.get()
}

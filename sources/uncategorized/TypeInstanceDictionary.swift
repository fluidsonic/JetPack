public struct TypeInstanceDictionary {

	private var instances = [ObjectIdentifier : Any]()


	public init() {}


	// Be very careful to not call this method with an Optional or an ImplicitlyUnwrappedOptional type. Use `as` in this case to convert the instance type to a non-optional first.
	public mutating func assign<T>(instance: T) {
		assign(instance, forType: T.self)
	}
	

	public mutating func assign<T>(instance: T, toType type: T.Type) {
		let id = ObjectIdentifier(type)
		if let existingInstance = instances[id] {
			fatalError("Cannot assign instance \(instance) to type \(type) because instance \(existingInstance) is already assigned")
		}

		instances[id] = instance
	}
	

	/*
	public final func add(object: AnyObject, forUncheckedProtocolId id: ObjectIdentifier) {
		objects[id] = object
	}
*/


	// Be very careful to not call this method with an Optional or an ImplicitlyUnwrappedOptional type. Use `as` in this case to expect the returned instance to be a non-optional.
	public func get<T>() -> T {
		return get(T.self)
	}


	public func get<T>(type: T.Type) -> T {
		let id = ObjectIdentifier(type)
		if let instance = instances[id] as! T? {
			return instance
		}

		fatalError("No instance was assigned to type \(type).")
	}
}


prefix operator << {}

public prefix func << <T>(dictionary: TypeInstanceDictionary) -> T {
	return dictionary.get()
}

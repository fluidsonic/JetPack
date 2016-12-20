public struct TypeInstanceDictionary {

	fileprivate var instances = [ObjectIdentifier : Any]()


	public init() {}


	// Be very careful to not call this method with an Optional or an ImplicitlyUnwrappedOptional type. Use `as` in this case to convert the instance type to a non-optional first.
	public mutating func assign<T>(_ instance: T) {
		assign(instance, toType: T.self)
	}
	

	public mutating func assign<T>(_ instance: T, toType type: T.Type) {
		let id = ObjectIdentifier(type)
		if let existingInstance = instances[id] {
			fatalError("Cannot assign instance \(instance) to type \(type) because instance \(existingInstance) is already assigned")
		}

		instances[id] = instance
	}


	// Be very careful to not call this method with an Optional or an ImplicitlyUnwrappedOptional type. Use `as` in this case to expect the returned instance to be a non-optional.
	public func get<T>() -> T? {
		return get(T.self)
	}


	public func get<T>(_ type: T.Type) -> T? {
		let id = ObjectIdentifier(type)
		return instances[id] as! T?
	}


	// Be very careful to not call this method with an Optional or an ImplicitlyUnwrappedOptional type. Use `as` in this case to expect the returned instance to be a non-optional.
	public func require<T>() -> T {
		return require(T.self)
	}


	public func require<T>(_ type: T.Type) -> T {
		guard let instance = get(type) else {
			fatalError("No instance was assigned to type \(type).")
		}

		return instance
	}


	// Be very careful to not call this method with an Optional or an ImplicitlyUnwrappedOptional type. Use `as` in this case to convert the instance type to a non-optional first.
	public mutating func unassign<T>(_ type: T.Type) -> T? {
		let id = ObjectIdentifier(type)
		return instances.removeValue(forKey: id) as! T?
	}
}


prefix operator <?
prefix operator <!

public prefix func <? <T>(dictionary: TypeInstanceDictionary) -> T? {
	return dictionary.get()
}

public prefix func <! <T>(dictionary: TypeInstanceDictionary) -> T {
	return dictionary.require()
}

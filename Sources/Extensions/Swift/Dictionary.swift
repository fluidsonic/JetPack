public extension Dictionary {

	
	public func filterAsDictionary(includeElement: (_ key: Key, _ value: Value) throws -> Bool) rethrows -> [Key : Value] {
		var filteredDictionary = [Key : Value]()
		for (key, value) in self where try includeElement(key, value) {
			filteredDictionary[key] = value
		}

		return filteredDictionary
	}


	public mutating func filterInPlace(includeElement: (_ key: Key, _ value: Value) throws -> Bool) rethrows {
		for (key, value) in self where !(try includeElement(key, value)) {
			self[key] = nil
		}
	}


	
	public func mapAsDictionary<K: Hashable, V>(transform: (_ key: Key, _ value: Value) throws -> (K, V)) rethrows -> [K : V] {
		var mappedDictionary = [K : V](minimumCapacity: count)
		for (key, value) in self {
			let (mappedKey, mappedValue) = try transform(key, value)
			mappedDictionary[mappedKey] = mappedValue
		}

		return mappedDictionary
	}


	
	public func mapAsDictionaryNotNil<K: Hashable, V>(transform: (_ key: Key, _ value: Value) throws -> (K?, V?)) rethrows -> [K : V] {
		var mappedDictionary = [K : V](minimumCapacity: count)
		for (key, value) in self {
			let (mappedKey, mappedValue) = try transform(key, value)
			if let mappedKey = mappedKey, let mappedValue = mappedValue {
				mappedDictionary[mappedKey] = mappedValue
			}
		}

		return mappedDictionary
	}


	public mutating func mapInPlace(transform: (_ value: Value) throws -> Value) rethrows {
		for (key, value) in self {
			self[key] = try transform(value)
		}
	}


	mutating func updateValues(_ fromDictionary: [Key : Value]) {
		for (key, value) in fromDictionary {
			updateValue(value, forKey: key)
		}
	}
}

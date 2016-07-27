public extension Dictionary {

	@warn_unused_result(mutable_variant="filterInPlace")
	public func filterAsDictionary(@noescape includeElement: (key: Key, value: Value) throws -> Bool) rethrows -> [Key : Value] {
		var filteredDictionary = [Key : Value]()
		for (key, value) in self where try includeElement(key: key, value: value) {
			filteredDictionary[key] = value
		}

		return filteredDictionary
	}


	public mutating func filterInPlace(@noescape includeElement: (key: Key, value: Value) throws -> Bool) rethrows {
		for (key, value) in self where !(try includeElement(key: key, value: value)) {
			self[key] = nil
		}
	}


	@warn_unused_result(mutable_variant="mapInPlace")
	public func mapAsDictionary<K: Hashable, V>(@noescape transform: (key: Key, value: Value) throws -> (K, V)) rethrows -> [K : V] {
		var mappedDictionary = [K : V](minimumCapacity: count)
		for (key, value) in self {
			let (mappedKey, mappedValue) = try transform(key: key, value: value)
			mappedDictionary[mappedKey] = mappedValue
		}

		return mappedDictionary
	}


	@warn_unused_result
	public func mapAsDictionaryNotNil<K: Hashable, V>(@noescape transform: (key: Key, value: Value) throws -> (K?, V?)) rethrows -> [K : V] {
		var mappedDictionary = [K : V](minimumCapacity: count)
		for (key, value) in self {
			let (mappedKey, mappedValue) = try transform(key: key, value: value)
			if let mappedKey = mappedKey, mappedValue = mappedValue {
				mappedDictionary[mappedKey] = mappedValue
			}
		}

		return mappedDictionary
	}


	public mutating func mapInPlace(@noescape transform: (value: Value) throws -> Value) rethrows {
		for (key, value) in self {
			self[key] = try transform(value: value)
		}
	}


	mutating func updateValues(fromDictionary: [Key : Value]) {
		for (key, value) in fromDictionary {
			updateValue(value, forKey: key)
		}
	}
}

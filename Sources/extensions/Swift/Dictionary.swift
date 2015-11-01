public extension Dictionary {

	@warn_unused_result(mutable_variant="mapInPlace")
	public func mapAsDictionary<K: Hashable, V>(@noescape transform: (Key, Value) throws -> (K, V)) rethrows -> [K : V] {
		var mappedDictionary = [K : V](minimumCapacity: count)
		for (key, value) in self {
			let (mappedKey, mappedValue) = try transform(key, value)
			mappedDictionary[mappedKey] = mappedValue
		}

		return mappedDictionary
	}


	public mutating func mapInPlace(@noescape transform: Value throws -> Value) rethrows {
		for (key, value) in self {
			self[key] = try transform(value)
		}
	}


	mutating func updateValues(fromDictionary: [Key : Value]) {
		for (key, value) in fromDictionary {
			updateValue(value, forKey: key)
		}
	}
}

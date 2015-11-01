public extension Dictionary {

	@warn_unused_result(mutable_variant="mapInPlace")
	public func mapAsDictionary<K: Hashable, V>(transform: (Key, Value) -> (K, V)) -> [K : V] {
		var mappedDictionary = [K : V](minimumCapacity: count)
		for (key, value) in self {
			let (mappedKey, mappedValue) = transform(key, value)
			mappedDictionary[mappedKey] = mappedValue
		}

		return mappedDictionary
	}


	public mutating func mapInPlace(transform: Value -> Value) {
		for (key, value) in self {
			self[key] = transform(value)
		}
	}


	mutating func updateValues(fromDictionary: [Key : Value]) {
		for (key, value) in fromDictionary {
			updateValue(value, forKey: key)
		}
	}
}

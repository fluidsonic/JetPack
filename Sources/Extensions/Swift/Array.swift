public extension Array {

	@warn_unused_result
	public func getOrNil(index: Index) -> Generator.Element? {
		guard indices.contains(index) else {
			return nil
		}

		return self[index]
	}


	@warn_unused_result
	public func toArray() -> [Generator.Element] {
		return self
	}
}


public func === <T: AnyObject> (a: [T], b: [T]) -> Bool {
	guard a.count == b.count else {
		return false
	}

	for index in a.indices {
		guard a[index] === b[index] else {
			return false
		}
	}

	return true
}


public func !== <T: AnyObject> (a: [T], b: [T]) -> Bool {
	return !(a === b)
}

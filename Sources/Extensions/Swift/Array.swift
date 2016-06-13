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

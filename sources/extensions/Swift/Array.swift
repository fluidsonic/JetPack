// until we no longer need MODULE.conflictedName (MODULE can vary depending on how you use this framework)

private func _first<S : SequenceType>(source: S, includeElement: (S.Generator.Element) -> Bool) -> S.Generator.Element? {
	return first(source, includeElement: includeElement)
}

private func _separate<E, S : SequenceType where S.Generator.Element == E>(source: S, isLeftElement: (E) -> Bool) -> ([E], [E]) {
	return separate(source, isLeftElement: isLeftElement)
}


public extension Array {

	public func first(includeElement: Element -> Bool) -> Element? {
		return _first(self, includeElement: includeElement)
	}


	public var randomElement: Element? {
		if isEmpty {
			return nil
		}

		return self[Int(arc4random_uniform(UInt32(count)))]
	}


	public func separate(isLeftElement: Element -> Bool) -> ([Element], [Element]) {
		return _separate(self, isLeftElement: isLeftElement)
	}
}

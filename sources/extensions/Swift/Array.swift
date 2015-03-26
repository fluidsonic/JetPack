// make public once the compiler allows it

// until we no longer need MODULE.conflictedName (MODULE can vary depending on how you use this framework)

private func _first<S : SequenceType>(source: S, includeElement: (S.Generator.Element) -> Bool) -> S.Generator.Element? {
	return first(source, includeElement)
}

private func _separate<E, S : SequenceType where S.Generator.Element == E>(source: S, isLeftElement: (E) -> Bool) -> ([E], [E]) {
	return separate(source, isLeftElement)
}


extension Array {

	func first(includeElement: T -> Bool) -> T? {
		return _first(self, includeElement)
	}


	var randomElement: T? {
		if isEmpty {
			return nil
		}

		return self[Int(arc4random_uniform(UInt32(count)))]
	}


	func separate(isLeftElement: T -> Bool) -> ([T], [T]) {
		return _separate(self, isLeftElement)
	}
}

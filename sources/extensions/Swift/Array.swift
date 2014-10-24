// make public once the compiler allows it

// until we no longer need MODULE.conflictedName (MODULE can vary depending on how you use this framework)
private func _separate<E, S : SequenceType where S.Generator.Element == E>(source: S, isLeftElement: (E) -> Bool) -> ([E], [E]) {
	return separate(source, isLeftElement)
}


extension Array {

	func separate(isLeftElement: T -> Bool) -> ([T], [T]) {
		return _separate(self, isLeftElement)
	}
}

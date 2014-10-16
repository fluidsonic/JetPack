extension Array {

	func separate(isLeftElement: T -> Bool) -> ([T], [T]) {
		return JetPack.separate(self, isLeftElement)
	}
}

public extension SignedNumeric where Self: Comparable {

	var sign: Self {
		if self == 0 {
			return 0
		}
		if self < 0 {
			return -1
		}

		return 1
	}
}

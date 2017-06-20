#if swift(>=3.2)

	extension SignedNumeric {

		public var absolute: Magnitude {
			return magnitude
		}
	}

#else

	public extension AbsoluteValuable {

		public var absolute: Self {
			return Self.abs(self)
		}
	}

#endif

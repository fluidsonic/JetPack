public enum UnitSystem {

	case American
	case British
	case SI


	public func select<T>(#si: T, american: T, british: T) -> T {
		switch self {
		case .American: return american
		case .British:  return british
		case .SI:       return si
		}
	}
}

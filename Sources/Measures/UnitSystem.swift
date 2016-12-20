public enum UnitSystem {

	case american
	case british
	case si


	public func select<T>(si: T, american: T, british: T) -> T {
		switch self {
		case .american: return american
		case .british:  return british
		case .si:       return si
		}
	}
}

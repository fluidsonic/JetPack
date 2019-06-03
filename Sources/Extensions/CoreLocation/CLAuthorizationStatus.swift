import CoreLocation


extension CLAuthorizationStatus: CustomStringConvertible {

	public var description: String {
		switch self {
		case .authorizedAlways:    return ".authorizedAlways"
		case .authorizedWhenInUse: return ".authorizedWhenInUse"
		case .denied:              return ".denied"
		case .notDetermined:       return ".notDetermined"
		case .restricted:          return ".restricted"
		@unknown default:          return ".\(rawValue)"
		}
	}
}

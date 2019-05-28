import CoreLocation


public extension CLLocationCoordinate2D {

	func distanceTo(_ coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
		return CLLocation(coordinate: self).distance(from: CLLocation(coordinate: coordinate))
	}
}


extension CLLocationCoordinate2D: Hashable {

	public func hash(into hasher: inout Hasher) {
		hasher.combine(latitude)
		hasher.combine(longitude)
	}


	public static func == (a: CLLocationCoordinate2D, b: CLLocationCoordinate2D) -> Bool {
		return a.latitude == b.latitude && a.longitude == b.longitude
	}
}

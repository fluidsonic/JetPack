import CoreLocation


public extension CLLocationCoordinate2D {

	
	public func distanceTo(_ coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
		return CLLocation(coordinate: self).distance(from: CLLocation(coordinate: coordinate))
	}
}


extension CLLocationCoordinate2D: Hashable {

	public var hashValue: Int {
		return latitude.hashValue ^ longitude.hashValue
	}


	public static func == (a: CLLocationCoordinate2D, b: CLLocationCoordinate2D) -> Bool {
		return a.latitude == b.latitude && a.longitude == b.longitude
	}
}

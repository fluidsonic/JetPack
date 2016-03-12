import CoreLocation


extension CLLocationCoordinate2D: Equatable {}


public func == (a: CLLocationCoordinate2D, b: CLLocationCoordinate2D) -> Bool {
	return a.latitude == b.latitude && a.longitude == b.longitude
}

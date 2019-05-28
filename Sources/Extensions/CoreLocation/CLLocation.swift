import CoreLocation


public extension CLLocation {

	@nonobjc
	convenience init(coordinate: CLLocationCoordinate2D) {
		self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
	}
}

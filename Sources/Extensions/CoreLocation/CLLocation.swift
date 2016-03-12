import CoreLocation


public extension CLLocation {

	@nonobjc
	public convenience init(coordinate: CLLocationCoordinate2D) {
		self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
	}
}

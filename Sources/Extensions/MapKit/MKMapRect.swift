import MapKit


public extension MKMapRect {

	public init(region: MKCoordinateRegion) {
		let bottomLeft = MKMapPointForCoordinate(CLLocationCoordinate2D(latitude: region.center.latitude + region.span.latitudeDelta / 2, longitude: region.center.longitude - region.span.longitudeDelta / 2))
		let topRight = MKMapPointForCoordinate(CLLocationCoordinate2D(latitude: region.center.latitude - region.span.latitudeDelta / 2, longitude: region.center.longitude + region.span.longitudeDelta / 2))

		self = MKMapRectMake(min(bottomLeft.x, topRight.x), min(bottomLeft.y, topRight.y), abs(bottomLeft.x - topRight.x), abs(bottomLeft.y - topRight.y))
	}


	
	public func contains(_ point: MKMapPoint) -> Bool {
		return MKMapRectContainsPoint(self, point)
	}


	
	public func contains(_ rect: MKMapRect) -> Bool {
		return MKMapRectContainsRect(self, rect)
	}


	public mutating func insetBy(horizontally horizontal: Double, vertically vertical: Double = 0) {
		self = insettedBy(horizontally: horizontal, vertically: vertical)
	}


	public mutating func insetBy(vertically vertical: Double) {
		insetBy(horizontally: 0, vertically: vertical)
	}


	
	public func insettedBy(horizontally horizontal: Double, vertically vertical: Double = 0) -> MKMapRect {
		return MKMapRectInset(self, horizontal, vertical)
	}


	
	public func insettedBy(vertically vertical: Double) -> MKMapRect {
		return insettedBy(horizontally: 0, vertically: vertical)
	}


	public mutating func scaleBy(_ scale: Double) {
		scaleBy(horizontally: scale, vertically: scale)
	}


	public mutating func scaleBy(horizontally horizontal: Double, vertically vertical: Double = 1) {
		self = scaledBy(horizontally: horizontal, vertically: vertical)
	}


	public mutating func scaleBy(vertically vertical: Double) {
		scaleBy(horizontally: 1, vertically: vertical)
	}


	
	public func scaledBy(_ scale: Double) -> MKMapRect {
		return scaledBy(horizontally: scale, vertically: scale)
	}


	
	public func scaledBy(horizontally horizontal: Double, vertically vertical: Double = 1) -> MKMapRect {
		return insettedBy(horizontally: (size.width / 2) * horizontal, vertically: (size.height / 2) * vertical)
	}


	
	public func scaledBy(vertically vertical: Double) -> MKMapRect {
		return scaledBy(horizontally: 1, vertically: vertical)
	}
}

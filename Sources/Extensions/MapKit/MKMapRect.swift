import MapKit


public extension MKMapRect {

	public init(region: MKCoordinateRegion) {
		let bottomLeft = MKMapPoint(CLLocationCoordinate2D(latitude: region.center.latitude + region.span.latitudeDelta / 2, longitude: region.center.longitude - region.span.longitudeDelta / 2))
		let topRight = MKMapPoint(CLLocationCoordinate2D(latitude: region.center.latitude - region.span.latitudeDelta / 2, longitude: region.center.longitude + region.span.longitudeDelta / 2))

		self = MKMapRect(
			x:      min(bottomLeft.x, topRight.x),
			y:      min(bottomLeft.y, topRight.y),
			width:  abs(bottomLeft.x - topRight.x),
			height: abs(bottomLeft.y - topRight.y)
		)
	}


	@available(*, unavailable, message: "use .insetBy(dx:dy)")
	public mutating func insetBy(horizontally horizontal: Double, vertically vertical: Double = 0) {
		self = insetBy(dx: horizontal, dy: vertical)
	}


	@available(*, unavailable, message: "use .insetBy(dx:dy)")
	public mutating func insetBy(vertically vertical: Double) {
		self = insetBy(dx: 0, dy: vertical)
	}


	@available(*, unavailable, renamed: "insetBy(dx:dy:)")
	public func insettedBy(horizontally horizontal: Double, vertically vertical: Double = 0) -> MKMapRect {
		return insetBy(dx: horizontal, dy: vertical)
	}


	@available(*, unavailable, message: "use .insetBy(dx:dy)")
	public func insettedBy(vertically vertical: Double) -> MKMapRect {
		return insetBy(dx: 0, dy: vertical)
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
		return insetBy(dx: (size.width / 2) * horizontal, dy: (size.height / 2) * vertical)
	}


	public func scaledBy(vertically vertical: Double) -> MKMapRect {
		return scaledBy(horizontally: 1, vertically: vertical)
	}
}


extension MKMapRect: Equatable {

	public static func == (a: MKMapRect, b: MKMapRect) -> Bool {
		return MKMapRectEqualToRect(a, b)
	}
}

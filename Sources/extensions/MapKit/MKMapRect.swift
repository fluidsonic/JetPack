import MapKit


public extension MKMapRect {

	@warn_unused_result
	public func contains(point: MKMapPoint) -> Bool {
		return MKMapRectContainsPoint(self, point)
	}


	@warn_unused_result
	public func contains(rect: MKMapRect) -> Bool {
		return MKMapRectContainsRect(self, rect)
	}


	public mutating func insetBy(horizontally horizontal: Double, vertically vertical: Double = 0) {
		self = insettedBy(horizontally: horizontal, vertically: vertical)
	}


	public mutating func insetBy(vertically vertical: Double) {
		insetBy(horizontally: 0, vertically: vertical)
	}


	@warn_unused_result(mutable_variant="insetBy")
	public func insettedBy(horizontally horizontal: Double, vertically vertical: Double = 0) -> MKMapRect {
		return MKMapRectInset(self, horizontal, vertical)
	}


	@warn_unused_result(mutable_variant="insetBy")
	public func insettedBy(vertically vertical: Double) -> MKMapRect {
		return insettedBy(horizontally: 0, vertically: vertical)
	}


	public mutating func scaleBy(scale: Double) {
		scaleBy(horizontally: scale, vertically: scale)
	}


	public mutating func scaleBy(horizontally horizontal: Double, vertically vertical: Double = 1) {
		self = scaledBy(horizontally: horizontal, vertically: vertical)
	}


	public mutating func scaleBy(vertically vertical: Double) {
		scaleBy(horizontally: 1, vertically: vertical)
	}


	@warn_unused_result(mutable_variant="scaleBy")
	public func scaledBy(scale: Double) -> MKMapRect {
		return scaledBy(horizontally: scale, vertically: scale)
	}


	@warn_unused_result(mutable_variant="scaleBy")
	public func scaledBy(horizontally horizontal: Double, vertically vertical: Double = 1) -> MKMapRect {
		return insettedBy(horizontally: (size.width / 2) * horizontal, vertically: (size.height / 2) * vertical)
	}


	@warn_unused_result(mutable_variant="scaleBy")
	public func scaledBy(vertically vertical: Double) -> MKMapRect {
		return scaledBy(horizontally: 1, vertically: vertical)
	}
}

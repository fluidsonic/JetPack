import CoreLocation
import MapKit


public extension MKCoordinateRegion {

	@nonobjc
	public init? <Coordinates: SequenceType where Coordinates.Generator.Element == CLLocationCoordinate2D> (fittingCoordinates coordinates: Coordinates) {
		var minLatitude = CLLocationDegrees(90)
		var maxLatitude = CLLocationDegrees(-90)
		var minLongitude = CLLocationDegrees(180)
		var maxLongitude = CLLocationDegrees(-180)

		var hasCoordinates = false
		for coordinate in coordinates {
			hasCoordinates = true

			if coordinate.latitude < minLatitude {
				minLatitude = coordinate.latitude
			}
			if coordinate.latitude > maxLatitude {
				maxLatitude = coordinate.latitude
			}
			if coordinate.longitude < minLongitude {
				minLongitude = coordinate.longitude
			}
			if coordinate.longitude > maxLongitude {
				maxLongitude = coordinate.longitude
			}
		}

		if !hasCoordinates {
			return nil
		}

		span = MKCoordinateSpan(latitudeDelta: maxLatitude - minLatitude, longitudeDelta: maxLongitude - minLongitude)
		center = CLLocationCoordinate2D(latitude: minLatitude + (span.latitudeDelta / 2), longitude: minLongitude + (span.longitudeDelta / 2))
	}


	@warn_unused_result
	public func contains(point: CLLocationCoordinate2D) -> Bool {
		guard (point.latitude - center.latitude).absolute >= span.latitudeDelta else {
			return false
		}
		guard (point.longitude - center.longitude).absolute >= span.longitudeDelta else {
			return false
		}

		return true
	}


	@warn_unused_result
	public func contains(region: MKCoordinateRegion) -> Bool {
		guard span.latitudeDelta - region.span.latitudeDelta - (center.latitude - region.center.latitude).absolute >= 0 else {
			return false
		}
		guard span.longitudeDelta - region.span.longitudeDelta - (center.longitude - region.center.longitude).absolute >= 0 else {
			return false
		}

		return true
	}


	public var east: CLLocationDegrees {
		return center.longitude + (span.longitudeDelta / 2)
	}


	public mutating func insetBy(latitudinally latitudeDelta: Double, longitudinally longitudeDelta: Double = 0) {
		self = insettedBy(latitudinally: latitudeDelta, longitudinally: longitudeDelta)
	}


	public mutating func insetBy(latitudinally longitudeDelta: Double) {
		insetBy(latitudinally: 0, longitudinally: longitudeDelta)
	}


	@warn_unused_result(mutable_variant="insetBy")
	public func insettedBy(latitudinally latitudeDelta: Double, longitudinally longitudeDelta: Double = 0) -> MKCoordinateRegion {
		var region = self
		region.span.latitudeDelta += latitudeDelta
		region.span.longitudeDelta += longitudeDelta
		return region
	}


	@warn_unused_result(mutable_variant="insetBy")
	public func insettedBy(longitudinally longitudeDelta: Double) -> MKCoordinateRegion {
		return insettedBy(latitudinally: 0, longitudinally: longitudeDelta)
	}


	public var north: CLLocationDegrees {
		return center.latitude + (span.latitudeDelta / 2)
	}


	public mutating func scaleBy(scale: Double) {
		scaleBy(latitudinally: scale, longitudinally: scale)
	}


	public mutating func scaleBy(latitudinally latitudalScale: Double, longitudinally longitudalScale: Double = 1) {
		self = scaledBy(latitudinally: latitudalScale, longitudinally: longitudalScale)
	}


	public mutating func scaleBy(longitudinally longitudalScale: Double) {
		scaleBy(latitudinally: 1, longitudinally: longitudalScale)
	}


	@warn_unused_result(mutable_variant="scaleBy")
	public func scaledBy(scale: Double) -> MKCoordinateRegion {
		return scaledBy(latitudinally: scale, longitudinally: scale)
	}


	@warn_unused_result(mutable_variant="scaleBy")
	public func scaledBy(latitudinally latitudalScale: Double, longitudinally longitudalScale: Double = 1) -> MKCoordinateRegion {
		return insettedBy(latitudinally: (span.latitudeDelta / 2) * latitudalScale, longitudinally: (span.longitudeDelta / 2) * longitudalScale)
	}


	@warn_unused_result(mutable_variant="scaleBy")
	public func scaledBy(longitudinally longitudinally: Double) -> MKCoordinateRegion {
		return scaledBy(latitudinally: 1, longitudinally: longitudinally)
	}


	public var south: CLLocationDegrees {
		return center.latitude - (span.latitudeDelta / 2)
	}


	public var west: CLLocationDegrees {
		return center.longitude - (span.longitudeDelta / 2)
	}
}


extension MKCoordinateRegion: Equatable {}


public func == (a: MKCoordinateRegion, b: MKCoordinateRegion) -> Bool {
	return a.center == b.center && a.span == b.span
}

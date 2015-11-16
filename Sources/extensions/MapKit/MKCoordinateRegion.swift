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
}

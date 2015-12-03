import MapKit


extension MKCoordinateSpan: Equatable {}


public func == (a: MKCoordinateSpan, b: MKCoordinateSpan) -> Bool {
	return a.latitudeDelta == b.latitudeDelta && a.longitudeDelta == b.longitudeDelta
}

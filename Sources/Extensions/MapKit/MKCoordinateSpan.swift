import MapKit


extension MKCoordinateSpan: Equatable {

	public static func == (a: MKCoordinateSpan, b: MKCoordinateSpan) -> Bool {
		return a.latitudeDelta == b.latitudeDelta && a.longitudeDelta == b.longitudeDelta
	}
}

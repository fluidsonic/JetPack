import MapKit


extension MKMapSnapshotOptions {

	open override func isEqual(_ object: Any?) -> Bool {
		guard let object = object as? MKMapSnapshotOptions else {
			return false
		}

		if object === self {
			return true
		}

		return camera == object.camera
			&& mapRect == object.mapRect
			&& mapType == object.mapType
			&& region == object.region
			&& scale == object.scale
			&& showsBuildings == object.showsBuildings
			&& showsPointsOfInterest == object.showsPointsOfInterest
			&& size == object.size
	}
}

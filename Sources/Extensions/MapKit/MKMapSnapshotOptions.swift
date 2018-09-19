import MapKit


extension MKMapSnapshotter.Options {

	open override func isEqual(_ object: Any?) -> Bool {
		guard let object = object as? MKMapSnapshotter.Options else {
			return false
		}

		if object === self {
			return true
		}

		#if os(iOS)
			return camera == object.camera
				&& mapRect == object.mapRect
				&& mapType == object.mapType
				&& region == object.region
				&& scale == object.scale
				&& showsBuildings == object.showsBuildings
				&& showsPointsOfInterest == object.showsPointsOfInterest
				&& size == object.size
		#else
			return camera == object.camera
				&& mapRect == object.mapRect
				&& mapType == object.mapType
				&& region == object.region
				&& showsBuildings == object.showsBuildings
				&& showsPointsOfInterest == object.showsPointsOfInterest
				&& size == object.size
		#endif
	}
}

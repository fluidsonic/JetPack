import CoreLocation


public extension CLLocationCoordinate2D {

	func distance(from coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
		return CLLocation(coordinate: self).distance(from: CLLocation(coordinate: coordinate))
	}


	@available(*, unavailable, renamed: "distance(from:)")
	func distanceTo(_ coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
		return CLLocation(coordinate: self).distance(from: CLLocation(coordinate: coordinate))
	}
}


extension CLLocationCoordinate2D: Codable {

	private enum CodingKeys: String, CodingKey {

		case latitude
		case longitude
	}


	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)

		self.init(
			latitude:  try values.decode(CLLocationDegrees.self, forKey: .latitude),
			longitude: try values.decode(CLLocationDegrees.self, forKey: .longitude)
		)
	}


	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(latitude, forKey: .latitude)
		try container.encode(longitude, forKey: .longitude)
	}
}


extension CLLocationCoordinate2D: Hashable {

	public func hash(into hasher: inout Hasher) {
		hasher.combine(latitude)
		hasher.combine(longitude)
	}


	public static func == (a: CLLocationCoordinate2D, b: CLLocationCoordinate2D) -> Bool {
		return a.latitude == b.latitude && a.longitude == b.longitude
	}
}

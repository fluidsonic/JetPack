private let degreesPerRadian = 180.0 / M_PI
private let radiansPerDegree = M_PI / 180.0


public struct Angle: Measurement {

	public static let name = "Angle"
	public static let rawUnit = AngleUnit.Degrees

	public var rawValue: Double


	public init(_ angle: Angle) {
		rawValue = angle.rawValue
	}


	public init(degree: Double) {
		rawValue = degree
	}


	public init(radian: Double) {
		rawValue = radian * degreesPerRadian
	}


	public init(rawValue: Double) {
		self.rawValue = rawValue
	}


	public var degrees: Double {
		return rawValue
	}


	public var radians: Double {
		return degrees * radiansPerDegree
	}
}


extension Angle: DebugPrintable {

	public var debugDescription: String {
		return "\(rawValue.description) \(Angle.rawUnit.debugDescription)"
	}
}


extension Angle: Hashable {

	public var hashValue: Int {
		return rawValue.hashValue
	}
}


extension Angle: Printable {

	public var description: String {
		return "\(rawValue.description) \(Angle.rawUnit.abbreviation)"
	}
}



public enum AngleUnit: Unit {
	case Degrees
	case Radians
}


extension AngleUnit {

	public var abbreviation: String {
		switch self {
		case .Degrees:
			return "deg"

		case .Radians:
			return "rad"
		}
	}


	public var pluralName: String {
		switch self {
		case .Degrees:
			return "Degrees"

		case .Radians:
			return "Radians"
		}
	}


	public var singularName: String {
		switch self {
		case .Degrees:
			return "Degree"

		case .Radians:
			return "Radian"
		}
	}


	public var symbol: String? {
		switch self {
		case .Degrees:
			return "°"

		case .Radians:
			return "\u{33AD}"
		}
	}
}


extension AngleUnit: DebugPrintable {

	public var debugDescription: String {
		return "AngleUnit(\(pluralName))"
	}
}


extension AngleUnit: Printable {

	public var description: String {
		return pluralName
	}
}

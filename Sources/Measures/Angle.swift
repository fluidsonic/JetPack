private let degreesPerRadian = 180.0 / .Pi
private let radiansPerDegree = .Pi / 180.0


public struct Angle: Measure {

	public static let name = MeasuresStrings.Measure.angle
	public static let rawUnit = AngleUnit.Degrees

	public var rawValue: Double


	public init(_ value: Double, unit: AngleUnit) {
		precondition(!value.isNaN, "Value must not be NaN.")

		switch unit {
		case .Degrees: rawValue = value
		case .Radians: rawValue = value * degreesPerRadian
		}
	}


	public init(degrees: Double) {
		self.init(degrees, unit: .Degrees)
	}


	public init(radians: Double) {
		self.init(radians, unit: .Radians)
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


	public func valueInUnit(unit: AngleUnit) -> Double {
		switch unit {
		case .Degrees: return degrees
		case .Radians: return radians
		}
	}
}



public enum AngleUnit: Unit {

	case Degrees
	case Radians
}


extension AngleUnit {

	public var abbreviation: String {
		switch self {
		case .Degrees: return MeasuresStrings.Unit.Degree.abbreviation
		case .Radians: return MeasuresStrings.Unit.Radian.abbreviation
		}
	}


	public var name: PluralizedString {
		switch self {
		case .Degrees: return MeasuresStrings.Unit.Degree.name
		case .Radians: return MeasuresStrings.Unit.Radian.name
		}
	}


	public var symbol: String? {
		switch self {
		case .Degrees: return "°"
		case .Radians: return "㎭"
		}
	}
}

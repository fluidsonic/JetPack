private let degreesPerRadian = 180.0 / .pi
private let radiansPerDegree = .pi / 180.0


public struct Angle: Measure {

	public static let name = MeasuresStrings.Measure.angle
	public static let rawUnit = AngleUnit.degrees

	public var rawValue: Double


	public init(_ value: Double, unit: AngleUnit) {
		precondition(!value.isNaN, "Value must not be NaN.")

		switch unit {
		case .degrees: rawValue = value
		case .radians: rawValue = value * degreesPerRadian
		}
	}


	public init(degrees: Double) {
		self.init(degrees, unit: .degrees)
	}


	public init(radians: Double) {
		self.init(radians, unit: .radians)
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


	public func valueInUnit(_ unit: AngleUnit) -> Double {
		switch unit {
		case .degrees: return degrees
		case .radians: return radians
		}
	}
}



public enum AngleUnit: Unit {

	case degrees
	case radians
}


extension AngleUnit {

	public var abbreviation: String {
		switch self {
		case .degrees: return MeasuresStrings.Unit.Degree.abbreviation
		case .radians: return MeasuresStrings.Unit.Radian.abbreviation
		}
	}


	public var name: PluralizedString {
		switch self {
		case .degrees: return MeasuresStrings.Unit.Degree.name
		case .radians: return MeasuresStrings.Unit.Radian.name
		}
	}


	public var symbol: String? {
		switch self {
		case .degrees: return "°"
		case .radians: return "㎭"
		}
	}
}

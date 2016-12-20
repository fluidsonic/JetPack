private let kmhPerKnot  = 1.852
private let kmhPerMph   = 1.609344
private let knotsPerKmh = 1.0 / kmhPerKnot
private let mphPerKmh   = 1.0 / kmhPerMph


public struct Speed: Measure {

	public static let name = MeasuresStrings.Measure.speed
	public static let rawUnit = SpeedUnit.kilometersPerHour

	public var rawValue: Double


	public init(_ value: Double, unit: SpeedUnit) {
		precondition(!value.isNaN, "Value must not be NaN.")
		
		switch unit {
		case .kilometersPerHour: rawValue = value
		case .knots:             rawValue = value * kmhPerKnot
		case .milesPerHour:      rawValue = value * kmhPerMph
		}
	}


	public init(kilometersPerHour: Double) {
		self.init(kilometersPerHour, unit: .kilometersPerHour)
	}


	public init(knots: Double) {
		self.init(knots, unit: .knots)
	}


	public init(milesPerHour: Double) {
		self.init(milesPerHour, unit: .milesPerHour)
	}


	public init(rawValue: Double) {
		self.rawValue = rawValue
	}


	public var kilometersPerHour: Double {
		return rawValue
	}


	public var knots: Double {
		return kilometersPerHour * knotsPerKmh
	}


	public var milesPerHour: Double {
		return kilometersPerHour * mphPerKmh
	}


	public func valueInUnit(_ unit: SpeedUnit) -> Double {
		switch unit {
		case .kilometersPerHour: return kilometersPerHour
		case .knots:             return knots
		case .milesPerHour:      return milesPerHour
		}
	}
}



public enum SpeedUnit: Unit {

	case kilometersPerHour
	case knots
	case milesPerHour
}


extension SpeedUnit {

	public var abbreviation: String {
		switch self {
		case .kilometersPerHour: return MeasuresStrings.Unit.KilometerPerHour.abbreviation
		case .knots:             return MeasuresStrings.Unit.Knot.abbreviation
		case .milesPerHour:      return MeasuresStrings.Unit.MilePerHour.abbreviation
		}
	}


	public var name: PluralizedString {
		switch self {
		case .kilometersPerHour: return MeasuresStrings.Unit.KilometerPerHour.name
		case .knots:             return MeasuresStrings.Unit.Knot.name
		case .milesPerHour:      return MeasuresStrings.Unit.MilePerHour.name
		}
	}


	public var symbol: String? {
		switch self {
		case .kilometersPerHour: return nil
		case .knots:             return nil
		case .milesPerHour:      return nil
		}
	}
}

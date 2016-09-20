private let kmhPerKnot  = 1.852
private let kmhPerMph   = 1.609344
private let knotsPerKmh = 1.0 / kmhPerKnot
private let mphPerKmh   = 1.0 / kmhPerMph


public struct Speed: Measure {

	public static let name = MeasuresStrings.Measure.speed
	public static let rawUnit = SpeedUnit.KilometersPerHour

	public var rawValue: Double


	public init(_ value: Double, unit: SpeedUnit) {
		precondition(!value.isNaN, "Value must not be NaN.")
		
		switch unit {
		case .KilometersPerHour: rawValue = value
		case .Knots:             rawValue = value * kmhPerKnot
		case .MilesPerHour:      rawValue = value * kmhPerMph
		}
	}


	public init(kilometersPerHour: Double) {
		self.init(kilometersPerHour, unit: .KilometersPerHour)
	}


	public init(knots: Double) {
		self.init(knots, unit: .Knots)
	}


	public init(milesPerHour: Double) {
		self.init(milesPerHour, unit: .MilesPerHour)
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


	public func valueInUnit(unit: SpeedUnit) -> Double {
		switch unit {
		case .KilometersPerHour: return kilometersPerHour
		case .Knots:             return knots
		case .MilesPerHour:      return milesPerHour
		}
	}
}



public enum SpeedUnit: Unit {

	case KilometersPerHour
	case Knots
	case MilesPerHour
}


extension SpeedUnit {

	public var abbreviation: String {
		switch self {
		case .KilometersPerHour: return MeasuresStrings.Unit.KilometerPerHour.abbreviation
		case .Knots:             return MeasuresStrings.Unit.Knot.abbreviation
		case .MilesPerHour:      return MeasuresStrings.Unit.MilePerHour.abbreviation
		}
	}


	public var name: PluralizedString {
		switch self {
		case .KilometersPerHour: return MeasuresStrings.Unit.KilometerPerHour.name
		case .Knots:             return MeasuresStrings.Unit.Knot.name
		case .MilesPerHour:      return MeasuresStrings.Unit.MilePerHour.name
		}
	}


	public var symbol: String? {
		switch self {
		case .KilometersPerHour: return nil
		case .Knots:             return nil
		case .MilesPerHour:      return nil
		}
	}
}

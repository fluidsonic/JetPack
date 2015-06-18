private let kmhPerKnot  = 1.852
private let kmhPerMph   = 1.609344
private let knotsPerKmh = 1.0 / kmhPerKnot
private let mphPerKmh   = 1.0 / kmhPerMph


public struct Speed: Measurement {

	public static let name = "Speed"
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


extension Speed: DebugPrintable {

	public var debugDescription: String {
		return "\(rawValue.description) \(Speed.rawUnit.debugDescription)"
	}
}


extension Speed: Hashable {

	public var hashValue: Int {
		return rawValue.hashValue
	}
}


extension Speed: Printable {

	public var description: String {
		return "\(rawValue.description) \(Speed.rawUnit.abbreviation)"
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
		case .KilometersPerHour:
			return "km/h"

		case .Knots:
			return "kn"

		case .MilesPerHour:
			return "mph"
		}
	}


	public var pluralName: String {
		switch self {
		case .KilometersPerHour:
			return "Kilometers per Hour"

		case .Knots:
			return "Knots"

		case .MilesPerHour:
			return "Miles per Hour"
		}
	}


	public var singularName: String {
		switch self {
		case .KilometersPerHour:
			return "Kilometer per Hour"

		case .Knots:
			return "Knot"

		case .MilesPerHour:
			return "Mile per Hour"
		}
	}


	public var symbol: String? {
		switch self {
		case .KilometersPerHour:
			return nil

		case .Knots:
			return nil

		case .MilesPerHour:
			return nil
		}
	}
}


extension SpeedUnit: DebugPrintable {

	public var debugDescription: String {
		return "SpeedUnit(\(pluralName))"
	}
}


extension SpeedUnit: Printable {

	public var description: String {
		return pluralName
	}
}

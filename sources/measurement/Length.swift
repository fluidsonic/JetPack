private let metersPerFeet      = 0.3048
private let metersPerInch      = 0.0254
private let metersPerKilometer = 1000.0
private let metersPerMile      = 1609.344
private let feetPerMeter       = 1.0 / metersPerFeet
private let inchPerMeter       = 1.0 / metersPerInch
private let kilometersPerMeter = 1.0 / metersPerKilometer
private let milesPerMeter      = 1.0 / metersPerMile


public struct Length: Measurement {

	public static let name = "Length"
	public static let rawUnit = LengthUnit.Meters

	public var rawValue: Double


	public init(_ length: Length) {
		rawValue = length.rawValue
	}


	public init(feet: Double) {
		rawValue = feet * metersPerFeet
	}


	public init(inches: Double) {
		rawValue = inches * metersPerInch
	}


	public init(kilometers: Double) {
		rawValue = kilometers * metersPerKilometer
	}


	public init(meters: Double) {
		rawValue = meters
	}


	public init(miles: Double) {
		rawValue = miles * metersPerMile
	}


	public init(rawValue: Double) {
		self.rawValue = rawValue
	}


	public var feet: Double {
		return meters * feetPerMeter
	}


	public var inches: Double {
		return meters * inchPerMeter
	}


	public var kilometers: Double {
		return meters * kilometersPerMeter
	}


	public var meters: Double {
		return rawValue
	}


	public var miles: Double {
		return meters * milesPerMeter
	}
}


extension Length: DebugPrintable {

	public var debugDescription: String {
		return "\(rawValue.description) \(Length.rawUnit.debugDescription)"
	}
}


extension Length: Hashable {

	public var hashValue: Int {
		return rawValue.hashValue
	}
}


extension Length: Printable {

	public var description: String {
		return "\(rawValue.description) \(Length.rawUnit.abbreviation)"
	}
}



public enum LengthUnit: Unit {
	case Feet
	case Inches
	case Kilometers
	case Meters
	case Miles
}


extension LengthUnit {

	public var abbreviation: String {
		switch self {
		case .Feet:
			return "ft"

		case .Inches:
			return "in"

		case .Kilometers:
			return "km"

		case .Meters:
			return "m"

		case .Miles:
			return "mi"
		}
	}


	public var pluralName: String {
		switch self {
		case .Feet:
			return "Feet"

		case .Inches:
			return "Inches"

		case .Kilometers:
			return "Kilometers"

		case .Meters:
			return "Meters"

		case .Miles:
			return "Miles"
		}
	}


	public var singularName: String {
		switch self {
		case .Feet:
			return "Foot"

		case .Inches:
			return "Inch"

		case .Kilometers:
			return "Kilometer"

		case .Meters:
			return "Meter"

		case .Miles:
			return "Mile"
		}
	}


	public var symbol: String? {
		switch self {
		case .Feet:
			return "′"

		case .Inches:
			return "″"

		case .Kilometers:
			return nil

		case .Meters:
			return nil

		case .Miles:
			return nil
		}
	}
}


extension LengthUnit: DebugPrintable {

	public var debugDescription: String {
		return "LengthUnit(\(pluralName))"
	}
}


extension LengthUnit: Printable {

	public var description: String {
		return pluralName
	}
}

private let metersPerCentimeter = 0.01
private let metersPerFoot       = 0.3048
private let metersPerInch       = 0.0254
private let metersPerKilometer  = 1000.0
private let metersPerMile       = 1609.344
private let centimetersPerMeter = 1.0 / metersPerCentimeter
private let feetPerMeter        = 1.0 / metersPerFoot
private let inchesPerMeter      = 1.0 / metersPerInch
private let kilometersPerMeter  = 1.0 / metersPerKilometer
private let milesPerMeter       = 1.0 / metersPerMile


public struct Length: Measure {

	public static let name = MeasuresStrings.Measure.length
	public static let rawUnit = LengthUnit.Meters

	public var rawValue: Double


	public init(_ value: Double, unit: LengthUnit) {
		precondition(!value.isNaN, "Value must not be NaN.")

		switch unit {
		case .Centimeters: rawValue = value * metersPerCentimeter
		case .Feet:        rawValue = value * metersPerFoot
		case .Inches:      rawValue = value * metersPerInch
		case .Kilometers:  rawValue = value * metersPerKilometer
		case .Meters:      rawValue = value
		case .Miles:       rawValue = value * metersPerMile
		}
	}


	public init(centimeters: Double) {
		self.init(centimeters, unit: .Centimeters)
	}


	public init(feet: Double) {
		self.init(feet, unit: .Feet)
	}


	public init(inches: Double) {
		self.init(inches, unit: .Inches)
	}


	public init(kilometers: Double) {
		self.init(kilometers, unit: .Kilometers)
	}


	public init(meters: Double) {
		self.init(meters, unit: .Meters)
	}


	public init(miles: Double) {
		self.init(miles, unit: .Miles)
	}


	public init(rawValue: Double) {
		self.rawValue = rawValue
	}


	public var centimeters: Double {
		return meters * centimetersPerMeter
	}


	public var feet: Double {
		return meters * feetPerMeter
	}


	public var inches: Double {
		return meters * inchesPerMeter
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


	public func valueInUnit(unit: LengthUnit) -> Double {
		switch unit {
		case .Centimeters: return centimeters
		case .Feet:        return feet
		case .Inches:      return inches
		case .Kilometers:  return kilometers
		case .Meters:      return meters
		case .Miles:       return miles
		}
	}
}



public enum LengthUnit: Unit {

	case Centimeters
	case Feet
	case Inches
	case Kilometers
	case Meters
	case Miles
}


extension LengthUnit {

	public var abbreviation: String {
		switch self {
		case .Centimeters: return MeasuresStrings.Unit.Centimeter.abbreviation
		case .Feet:        return MeasuresStrings.Unit.Foot.abbreviation
		case .Inches:      return MeasuresStrings.Unit.Inch.abbreviation
		case .Kilometers:  return MeasuresStrings.Unit.Kilometer.abbreviation
		case .Meters:      return MeasuresStrings.Unit.Meter.abbreviation
		case .Miles:       return MeasuresStrings.Unit.Mile.abbreviation
		}
	}


	public var name: PluralizedString {
		switch self {
		case .Centimeters: return MeasuresStrings.Unit.Centimeter.name
		case .Feet:        return MeasuresStrings.Unit.Foot.name
		case .Inches:      return MeasuresStrings.Unit.Inch.name
		case .Kilometers:  return MeasuresStrings.Unit.Kilometer.name
		case .Meters:      return MeasuresStrings.Unit.Meter.name
		case .Miles:       return MeasuresStrings.Unit.Mile.name
		}
	}


	public var symbol: String? {
		switch self {
		case .Centimeters: return nil
		case .Feet:        return "′"
		case .Inches:      return "″"
		case .Kilometers:  return nil
		case .Meters:      return nil
		case .Miles:       return nil
		}
	}
}

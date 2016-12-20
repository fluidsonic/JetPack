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
	public static let rawUnit = LengthUnit.meters

	public var rawValue: Double


	public init(_ value: Double, unit: LengthUnit) {
		precondition(!value.isNaN, "Value must not be NaN.")

		switch unit {
		case .centimeters: rawValue = value * metersPerCentimeter
		case .feet:        rawValue = value * metersPerFoot
		case .inches:      rawValue = value * metersPerInch
		case .kilometers:  rawValue = value * metersPerKilometer
		case .meters:      rawValue = value
		case .miles:       rawValue = value * metersPerMile
		}
	}


	public init(centimeters: Double) {
		self.init(centimeters, unit: .centimeters)
	}


	public init(feet: Double) {
		self.init(feet, unit: .feet)
	}


	public init(inches: Double) {
		self.init(inches, unit: .inches)
	}


	public init(kilometers: Double) {
		self.init(kilometers, unit: .kilometers)
	}


	public init(meters: Double) {
		self.init(meters, unit: .meters)
	}


	public init(miles: Double) {
		self.init(miles, unit: .miles)
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


	public func valueInUnit(_ unit: LengthUnit) -> Double {
		switch unit {
		case .centimeters: return centimeters
		case .feet:        return feet
		case .inches:      return inches
		case .kilometers:  return kilometers
		case .meters:      return meters
		case .miles:       return miles
		}
	}
}



public enum LengthUnit: Unit {

	case centimeters
	case feet
	case inches
	case kilometers
	case meters
	case miles
}


extension LengthUnit {

	public var abbreviation: String {
		switch self {
		case .centimeters: return MeasuresStrings.Unit.Centimeter.abbreviation
		case .feet:        return MeasuresStrings.Unit.Foot.abbreviation
		case .inches:      return MeasuresStrings.Unit.Inch.abbreviation
		case .kilometers:  return MeasuresStrings.Unit.Kilometer.abbreviation
		case .meters:      return MeasuresStrings.Unit.Meter.abbreviation
		case .miles:       return MeasuresStrings.Unit.Mile.abbreviation
		}
	}


	public var name: PluralizedString {
		switch self {
		case .centimeters: return MeasuresStrings.Unit.Centimeter.name
		case .feet:        return MeasuresStrings.Unit.Foot.name
		case .inches:      return MeasuresStrings.Unit.Inch.name
		case .kilometers:  return MeasuresStrings.Unit.Kilometer.name
		case .meters:      return MeasuresStrings.Unit.Meter.name
		case .miles:       return MeasuresStrings.Unit.Mile.name
		}
	}


	public var symbol: String? {
		switch self {
		case .centimeters: return nil
		case .feet:        return "′"
		case .inches:      return "″"
		case .kilometers:  return nil
		case .meters:      return nil
		case .miles:       return nil
		}
	}
}

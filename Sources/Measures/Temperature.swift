public struct Temperature: Measure {

	public static let name = MeasuresStrings.Measure.temperature
	public static let rawUnit = TemperatureUnit.DegreesCelsius

	public var rawValue: Double


	public init(_ value: Double, unit: TemperatureUnit) {
		precondition(!value.isNaN, "Value must not be NaN.")

		switch unit {
		case .DegreesCelsius:    rawValue = value
		case .DegreesFahrenheit: rawValue = (5.0 / 9.0) * (value - 32.0)
		}
	}


	public init(degreesCelsius: Double) {
		self.init(degreesCelsius, unit: .DegreesCelsius)
	}


	public init(degreesFahrenheit: Double) {
		self.init(degreesFahrenheit, unit: .DegreesFahrenheit)
	}


	public init(rawValue: Double) {
		self.rawValue = rawValue
	}


	public var degreesCelsius: Double {
		return rawValue
	}


	public var degreesFahrenheit: Double {
		return (1.8 * degreesCelsius) + 32
	}


	public func valueInUnit(unit: TemperatureUnit) -> Double {
		switch unit {
		case .DegreesCelsius:    return degreesCelsius
		case .DegreesFahrenheit: return degreesFahrenheit
		}
	}
}



public enum TemperatureUnit: Unit {

	case DegreesCelsius
	case DegreesFahrenheit
}


extension TemperatureUnit {

	public var abbreviation: String {
		switch self {
		case .DegreesCelsius:    return MeasuresStrings.Unit.DegreeCelsius.abbreviation
		case .DegreesFahrenheit: return MeasuresStrings.Unit.DegreeFahrenheit.abbreviation
		}
	}


	public var name: PluralizedString {
		switch self {
		case .DegreesCelsius:    return MeasuresStrings.Unit.DegreeCelsius.name
		case .DegreesFahrenheit: return MeasuresStrings.Unit.DegreeFahrenheit.name
		}
	}


	public var symbol: String? {
		switch self {
		case .DegreesCelsius:    return nil
		case .DegreesFahrenheit: return nil
		}
	}
}

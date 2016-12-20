public struct Temperature: Measure {

	public static let name = MeasuresStrings.Measure.temperature
	public static let rawUnit = TemperatureUnit.degreesCelsius

	public var rawValue: Double


	public init(_ value: Double, unit: TemperatureUnit) {
		precondition(!value.isNaN, "Value must not be NaN.")

		switch unit {
		case .degreesCelsius:    rawValue = value
		case .degreesFahrenheit: rawValue = (5.0 / 9.0) * (value - 32.0)
		}
	}


	public init(degreesCelsius: Double) {
		self.init(degreesCelsius, unit: .degreesCelsius)
	}


	public init(degreesFahrenheit: Double) {
		self.init(degreesFahrenheit, unit: .degreesFahrenheit)
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


	public func valueInUnit(_ unit: TemperatureUnit) -> Double {
		switch unit {
		case .degreesCelsius:    return degreesCelsius
		case .degreesFahrenheit: return degreesFahrenheit
		}
	}
}



public enum TemperatureUnit: Unit {

	case degreesCelsius
	case degreesFahrenheit
}


extension TemperatureUnit {

	public var abbreviation: String {
		switch self {
		case .degreesCelsius:    return MeasuresStrings.Unit.DegreeCelsius.abbreviation
		case .degreesFahrenheit: return MeasuresStrings.Unit.DegreeFahrenheit.abbreviation
		}
	}


	public var name: PluralizedString {
		switch self {
		case .degreesCelsius:    return MeasuresStrings.Unit.DegreeCelsius.name
		case .degreesFahrenheit: return MeasuresStrings.Unit.DegreeFahrenheit.name
		}
	}


	public var symbol: String? {
		switch self {
		case .degreesCelsius:    return nil
		case .degreesFahrenheit: return nil
		}
	}
}

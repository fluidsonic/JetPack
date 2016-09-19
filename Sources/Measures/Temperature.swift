public struct Temperature: Measure {

	public static let name = MeasuresStrings.Measurement.temperature
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


extension Temperature: CustomDebugStringConvertible {

	public var debugDescription: String {
		return "\(rawValue.description) \(Temperature.rawUnit.debugDescription)"
	}
}


extension Temperature: CustomStringConvertible {

	public var description: String {
		return "\(rawValue.description) \(Temperature.rawUnit.abbreviation)"
	}
}


extension Temperature: Hashable {

	public var hashValue: Int {
		return rawValue.hashValue
	}
}



public enum TemperatureUnit: Unit {
	case DegreesCelsius
	case DegreesFahrenheit
}


extension TemperatureUnit {

	public var abbreviation: String {
		switch self {
		case .DegreesCelsius:
			return MeasuresStrings.Unit.DegreeCelsius.abbreviation

		case .DegreesFahrenheit:
			return MeasuresStrings.Unit.DegreeFahrenheit.abbreviation
		}
	}


	public var pluralName: String {
		switch self {
		case .DegreesCelsius:
			return MeasuresStrings.Unit.DegreeCelsius.name.forPluralCategory(.many)

		case .DegreesFahrenheit:
			return MeasuresStrings.Unit.DegreeFahrenheit.name.forPluralCategory(.many)
		}
	}


	public var singularName: String {
		switch self {
		case .DegreesCelsius:
			return MeasuresStrings.Unit.DegreeCelsius.name.forPluralCategory(.one)

		case .DegreesFahrenheit:
			return MeasuresStrings.Unit.DegreeFahrenheit.name.forPluralCategory(.one)
		}
	}


	public var symbol: String? {
		switch self {
		case .DegreesCelsius:
			return nil

		case .DegreesFahrenheit:
			return nil
		}
	}
}


extension TemperatureUnit: CustomDebugStringConvertible {

	public var debugDescription: String {
		return "TemperatureUnit(\(pluralName))"
	}
}


extension TemperatureUnit: CustomStringConvertible {

	public var description: String {
		return pluralName
	}
}

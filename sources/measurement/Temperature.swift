public struct Temperature: Measurement {

	public static let name = "Temperature"
	public static let rawUnit = TemperatureUnit.DegreesCelsius

	public var rawValue: Double


	public init(_ temperature: Temperature) {
		rawValue = temperature.rawValue
	}


	public init(degreesCelsius: Double) {
		rawValue = degreesCelsius
	}


	public init(degreesFahrenheit: Double) {
		rawValue = (5.0 / 9.0) * (degreesFahrenheit - 32.0)
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
}


extension Temperature: DebugPrintable {

	public var debugDescription: String {
		return "\(rawValue.description) \(Temperature.rawUnit.debugDescription)"
	}
}


extension Temperature: Hashable {

	public var hashValue: Int {
		return rawValue.hashValue
	}
}


extension Temperature: Printable {

	public var description: String {
		return "\(rawValue.description) \(Temperature.rawUnit.abbreviation)"
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
			return "°C"

		case .DegreesFahrenheit:
			return "°F"
		}
	}


	public var pluralName: String {
		switch self {
		case .DegreesCelsius:
			return "Celsius"  // should we include 'Degrees'?

		case .DegreesFahrenheit:
			return "Fahrenheit"  // should we include 'Degrees'?
		}
	}


	public var singularName: String {
		switch self {
		case .DegreesCelsius:
			return "Celsius"  // should we include 'Degree'?

		case .DegreesFahrenheit:
			return "Fahrenheit"  // should we include 'Degree'?
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


extension TemperatureUnit: DebugPrintable {

	public var debugDescription: String {
		return "TemperatureUnit(\(pluralName))"
	}
}


extension TemperatureUnit: Printable {

	public var description: String {
		return pluralName
	}
}

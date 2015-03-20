public struct Pressure: Measurement {

	public static let name = "Pressure"
	public static let rawUnit = PressureUnit.Millibars

	public var rawValue: Double


	public init(_ pressure: Pressure) {
		rawValue = pressure.rawValue
	}


	public init(millibars: Double) {
		rawValue = millibars
	}


	public init(rawValue: Double) {
		self.rawValue = rawValue
	}


	public var millibars: Double {
		return rawValue
	}
}


extension Pressure: DebugPrintable {

	public var debugDescription: String {
		return "\(rawValue.description) \(Pressure.rawUnit.debugDescription)"
	}
}


extension Pressure: Hashable {

	public var hashValue: Int {
		return rawValue.hashValue
	}
}


extension Pressure: Printable {

	public var description: String {
		return "\(rawValue.description) \(Pressure.rawUnit.abbreviation)"
	}
}



public enum PressureUnit: Unit {
	case Millibars
}


extension PressureUnit {

	public var abbreviation: String {
		switch self {
		case .Millibars:
			return "mbar"
		}
	}


	public var pluralName: String {
		switch self {
		case .Millibars:
			return "Millibar"
		}
	}


	public var singularName: String {
		switch self {
		case .Millibars:
			return "Millibars"
		}
	}


	public var symbol: String? {
		switch self {
		case .Millibars:
			return nil
		}
	}
}


extension PressureUnit: DebugPrintable {

	public var debugDescription: String {
		return "PressureUnit(\(pluralName))"
	}
}


extension PressureUnit: Printable {

	public var description: String {
		return pluralName
	}
}

// TODO use SI unit for rawValue
// TODO make sure conversation millibar<>inHg is correct

private let inchesOfMercuryPerMillibar = 0.02953
private let millibarsPerInchOfMercury  = 1 / inchesOfMercuryPerMillibar


public struct Pressure: Measurement {

	public static let name = "Pressure"
	public static let rawUnit = PressureUnit.Millibars

	public var rawValue: Double


	public init(_ pressure: Pressure) {
		rawValue = pressure.rawValue
	}


	public init(inchesOfMercury: Double) {
		rawValue = inchesOfMercury * millibarsPerInchOfMercury
	}


	public init(millibars: Double) {
		rawValue = millibars
	}


	public init(rawValue: Double) {
		self.rawValue = rawValue
	}


	public var inchesOfMercury: Double {
		return millibars * inchesOfMercuryPerMillibar
	}


	public var millibars: Double {
		return rawValue
	}


	public func valueInUnit(unit: PressureUnit) -> Double {
		switch unit {
		case .InchesOfMercury: return inchesOfMercury
		case .Millibars:       return millibars
		}
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
	case InchesOfMercury
	case Millibars
}


extension PressureUnit {

	public var abbreviation: String {
		switch self {
		case .InchesOfMercury: return "inHg"
		case .Millibars:       return "mbar"
		}
	}
	

	public var pluralName: String {
		switch self {
		case .InchesOfMercury: return "Inches of Mercury"
		case .Millibars:       return "Millibars"
		}
	}


	public var singularName: String {
		switch self {
		case .InchesOfMercury: return "Inch of Mercury"
		case .Millibars:       return "Millibar"
		}
	}


	public var symbol: String? {
		switch self {
		case .InchesOfMercury: return "″Hg"
		case .Millibars:       return nil
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

// TODO use SI unit for rawValue
// TODO make sure conversation millibar<>inHg is correct

private let inchesOfMercuryPerMillibar = 0.02953
private let millibarsPerInchOfMercury  = 1 / inchesOfMercuryPerMillibar


public struct Pressure: Measure {

	public static let name = "Pressure"
	public static let rawUnit = PressureUnit.Millibars

	public var rawValue: Double


	public init(_ value: Double, unit: PressureUnit) {
		precondition(!value.isNaN, "Value must not be NaN.")
		
		switch unit {
		case .InchesOfMercury: rawValue = value * millibarsPerInchOfMercury
		case .Millibars:       rawValue = value
		}
	}


	public init(inchesOfMercury: Double) {
		self.init(inchesOfMercury, unit: .InchesOfMercury)
	}


	public init(millibars: Double) {
		self.init(millibars, unit: .Millibars)
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


extension Pressure: CustomDebugStringConvertible {

	public var debugDescription: String {
		return "\(rawValue.description) \(Pressure.rawUnit.debugDescription)"
	}
}


extension Pressure: CustomStringConvertible {

	public var description: String {
		return "\(rawValue.description) \(Pressure.rawUnit.abbreviation)"
	}
}


extension Pressure: Hashable {

	public var hashValue: Int {
		return rawValue.hashValue
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


extension PressureUnit: CustomDebugStringConvertible {

	public var debugDescription: String {
		return "PressureUnit(\(pluralName))"
	}
}


extension PressureUnit: CustomStringConvertible {

	public var description: String {
		return pluralName
	}
}

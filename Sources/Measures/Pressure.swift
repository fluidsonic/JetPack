// TODO use SI unit for rawValue
// TODO make sure conversation millibar<>inHg is correct

private let inchesOfMercuryPerMillibar = 0.02953
private let millibarsPerInchOfMercury  = 1 / inchesOfMercuryPerMillibar


public struct Pressure: Measure {

	public static let name = MeasuresStrings.Measure.pressure
	public static let rawUnit = PressureUnit.millibars

	public var rawValue: Double


	public init(_ value: Double, unit: PressureUnit) {
		precondition(!value.isNaN, "Value must not be NaN.")
		
		switch unit {
		case .inchesOfMercury: rawValue = value * millibarsPerInchOfMercury
		case .millibars:       rawValue = value
		}
	}


	public init(inchesOfMercury: Double) {
		self.init(inchesOfMercury, unit: .inchesOfMercury)
	}


	public init(millibars: Double) {
		self.init(millibars, unit: .millibars)
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


	public func valueInUnit(_ unit: PressureUnit) -> Double {
		switch unit {
		case .inchesOfMercury: return inchesOfMercury
		case .millibars:       return millibars
		}
	}
}



public enum PressureUnit: Unit {

	case inchesOfMercury
	case millibars
}


extension PressureUnit {

	public var abbreviation: String {
		switch self {
		case .inchesOfMercury: return MeasuresStrings.Unit.InchOfMercury.abbreviation
		case .millibars:       return MeasuresStrings.Unit.Millibar.abbreviation
		}
	}
	

	public var name: PluralizedString {
		switch self {
		case .inchesOfMercury: return MeasuresStrings.Unit.InchOfMercury.name
		case .millibars:       return MeasuresStrings.Unit.Millibar.name
		}
	}


	public var symbol: String? {
		switch self {
		case .inchesOfMercury: return "″Hg"
		case .millibars:       return nil
		}
	}
}

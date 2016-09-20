// TODO use SI unit for rawValue
// TODO make sure conversation millibar<>inHg is correct

private let inchesOfMercuryPerMillibar = 0.02953
private let millibarsPerInchOfMercury  = 1 / inchesOfMercuryPerMillibar


public struct Pressure: Measure {

	public static let name = MeasuresStrings.Measure.pressure
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



public enum PressureUnit: Unit {

	case InchesOfMercury
	case Millibars
}


extension PressureUnit {

	public var abbreviation: String {
		switch self {
		case .InchesOfMercury: return MeasuresStrings.Unit.InchOfMercury.abbreviation
		case .Millibars:       return MeasuresStrings.Unit.Millibar.abbreviation
		}
	}
	

	public var name: PluralizedString {
		switch self {
		case .InchesOfMercury: return MeasuresStrings.Unit.InchOfMercury.name
		case .Millibars:       return MeasuresStrings.Unit.Millibar.name
		}
	}


	public var symbol: String? {
		switch self {
		case .InchesOfMercury: return "″Hg"
		case .Millibars:       return nil
		}
	}
}

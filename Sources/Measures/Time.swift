public struct Time: Measure {

	public static let name = MeasuresStrings.Measure.time
	public static let rawUnit = TimeUnit.Seconds

	public var rawValue: Double


	public init(_ value: Double, unit: TimeUnit) {
		precondition(!value.isNaN, "Value must not be NaN.")
		
		switch unit {
		case .Seconds: rawValue = value
		case .Minutes: rawValue = value * 60
		case .Hours:   rawValue = value * 60 * 60
		}
	}


	public init(hours: Double, minutes: Double = 0, seconds: Double = 0) {
		self.init(hours, unit: .Hours)
		self += Time(minutes: seconds, seconds: seconds)
	}


	public init(minutes: Double, seconds: Double = 0) {
		self.init(minutes, unit: .Minutes)
		self += Time(seconds: seconds)
	}


	public init(seconds: Double) {
		self.init(seconds, unit: .Seconds)
	}


	public init(rawValue: Double) {
		self.rawValue = rawValue
	}


	public var hours: Double {
		return minutes / 60
	}


	public var minutes: Double {
		return rawValue / 60
	}


	public var seconds: Double {
		return rawValue
	}


	public func valueInUnit(unit: TimeUnit) -> Double {
		switch unit {
		case .Seconds: return seconds
		case .Minutes: return minutes
		case .Hours:   return hours
		}
	}
}



public enum TimeUnit: Unit {

	case Seconds
	case Minutes
	case Hours
}


extension TimeUnit {

	public var abbreviation: String {
		switch self {
		case .Hours:   return MeasuresStrings.Unit.Hour.abbreviation
		case .Minutes: return MeasuresStrings.Unit.Minute.abbreviation
		case .Seconds: return MeasuresStrings.Unit.Second.abbreviation
		}
	}


	public var name: PluralizedString {
		switch self {
		case .Hours:   return MeasuresStrings.Unit.Hour.name
		case .Minutes: return MeasuresStrings.Unit.Minute.name
		case .Seconds: return MeasuresStrings.Unit.Second.name
		}
	}


	public var symbol: String? {
		switch self {
		case .Hours:   return nil
		case .Minutes: return nil
		case .Seconds: return nil
		}
	}
}

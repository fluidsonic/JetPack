public struct Time: Measure {

	public static let name = MeasuresStrings.Measure.time
	public static let rawUnit = TimeUnit.seconds

	public var rawValue: Double


	public init(_ value: Double, unit: TimeUnit) {
		precondition(!value.isNaN, "Value must not be NaN.")
		
		switch unit {
		case .seconds: rawValue = value
		case .minutes: rawValue = value * 60
		case .hours:   rawValue = value * 60 * 60
		}
	}


	public init(hours: Double, minutes: Double = 0, seconds: Double = 0) {
		self.init(hours, unit: .hours)
		self += Time(minutes: seconds, seconds: seconds)
	}


	public init(minutes: Double, seconds: Double = 0) {
		self.init(minutes, unit: .minutes)
		self += Time(seconds: seconds)
	}


	public init(seconds: Double) {
		self.init(seconds, unit: .seconds)
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


	public func valueInUnit(_ unit: TimeUnit) -> Double {
		switch unit {
		case .seconds: return seconds
		case .minutes: return minutes
		case .hours:   return hours
		}
	}
}



public enum TimeUnit: Unit {

	case seconds
	case minutes
	case hours
}


extension TimeUnit {

	public var abbreviation: String {
		switch self {
		case .hours:   return MeasuresStrings.Unit.Hour.abbreviation
		case .minutes: return MeasuresStrings.Unit.Minute.abbreviation
		case .seconds: return MeasuresStrings.Unit.Second.abbreviation
		}
	}


	public var name: PluralizedString {
		switch self {
		case .hours:   return MeasuresStrings.Unit.Hour.name
		case .minutes: return MeasuresStrings.Unit.Minute.name
		case .seconds: return MeasuresStrings.Unit.Second.name
		}
	}


	public var symbol: String? {
		switch self {
		case .hours:   return nil
		case .minutes: return nil
		case .seconds: return nil
		}
	}
}

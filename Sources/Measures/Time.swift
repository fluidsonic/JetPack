public struct Time: Measure {

	public static let name = MeasuresStrings.Measurement.time
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


extension Time: CustomDebugStringConvertible {

	public var debugDescription: String {
		return "\(rawValue.description) \(Time.rawUnit.debugDescription)"
	}
}


extension Time: CustomStringConvertible {

	public var description: String {
		return "\(rawValue.description) \(Time.rawUnit.abbreviation)"
	}
}


extension Time: Hashable {

	public var hashValue: Int {
		return rawValue.hashValue
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


	public var pluralName: String {
		switch self {
		case .Hours:   return MeasuresStrings.Unit.Hour.name.forPluralCategory(.many)
		case .Minutes: return MeasuresStrings.Unit.Minute.name.forPluralCategory(.many)
		case .Seconds: return MeasuresStrings.Unit.Second.name.forPluralCategory(.many)
		}
	}


	public var singularName: String {
		switch self {
		case .Hours:   return MeasuresStrings.Unit.Hour.name.forPluralCategory(.one)
		case .Minutes: return MeasuresStrings.Unit.Minute.name.forPluralCategory(.one)
		case .Seconds: return MeasuresStrings.Unit.Second.name.forPluralCategory(.one)
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


extension TimeUnit: CustomDebugStringConvertible {

	public var debugDescription: String {
		return "TimeUnit(\(pluralName))"
	}
}


extension TimeUnit: CustomStringConvertible {

	public var description: String {
		return pluralName
	}
}

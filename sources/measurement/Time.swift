public struct Time: Measurement {

	public static let name = "Time"
	public static let rawUnit = TimeUnit.Seconds

	public var rawValue: Double


	public init(_ value: Double, unit: TimeUnit) {
		precondition(!value.isNaN, "Value must not be NaN.")
		
		switch unit {
		case .Seconds: rawValue = value
		}
	}


	public init(seconds: Double) {
		self.init(seconds, unit: .Seconds)
	}


	public init(rawValue: Double) {
		self.rawValue = rawValue
	}


	public var seconds: Double {
		return rawValue
	}


	public func valueInUnit(unit: TimeUnit) -> Double {
		switch unit {
		case .Seconds: return seconds
		}
	}
}


extension Time: DebugPrintable {

	public var debugDescription: String {
		return "\(rawValue.description) \(Time.rawUnit.debugDescription)"
	}
}


extension Time: Hashable {

	public var hashValue: Int {
		return rawValue.hashValue
	}
}


extension Time: Printable {

	public var description: String {
		return "\(rawValue.description) \(Time.rawUnit.abbreviation)"
	}
}



public enum TimeUnit: Unit {
	case Seconds
}


extension TimeUnit {

	public var abbreviation: String {
		switch self {
		case .Seconds:
			return "s"
		}
	}


	public var pluralName: String {
		switch self {
		case .Seconds:
			return "Second"
		}
	}


	public var singularName: String {
		switch self {
		case .Seconds:
			return "Seconds"
		}
	}


	public var symbol: String? {
		switch self {
		case .Seconds:
			return nil
		}
	}
}


extension TimeUnit: DebugPrintable {

	public var debugDescription: String {
		return "TimeUnit(\(pluralName))"
	}
}


extension TimeUnit: Printable {

	public var description: String {
		return pluralName
	}
}

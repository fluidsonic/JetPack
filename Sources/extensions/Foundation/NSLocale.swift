import Foundation


public extension NSLocale {

	@nonobjc
	public static let englishUnitedStatesComputer = NSLocale(localeIdentifier: "en_US_POSIX")


	@nonobjc
	public var uses24HourFormat: Bool {
		return !(NSDateFormatter.dateFormatFromTemplate("j", options: 0, locale: self)?.containsString("a") ?? false)
	}


	@nonobjc
	public var usesMetricSystem: Bool {
		return objectForKey(NSLocaleUsesMetricSystem) as? Bool ?? false
	}
}

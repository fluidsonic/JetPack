import Foundation


public extension NSLocale {

	@nonobjc
	public var uses24HourFormat: Bool {
		return !(NSDateFormatter.dateFormatFromTemplate("j", options: 0, locale: self)?.contains("a") ?? false)
	}


	@nonobjc
	public var usesMetricSystem: Bool {
		return objectForKey(NSLocaleUsesMetricSystem) as? Bool ?? false
	}
}

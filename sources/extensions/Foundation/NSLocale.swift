import Foundation


public extension NSLocale {

	public var uses24HourFormat: Bool {
		return !(NSDateFormatter.dateFormatFromTemplate("j", options: 0, locale: self)?.contains("a") ?? false)
	}


	public var usesMetricSystem: Bool {
		return objectForKey(NSLocaleUsesMetricSystem) as? Bool ?? false
	}
}

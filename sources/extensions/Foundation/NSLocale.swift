import Foundation


public extension NSLocale {

	public var usesMetricSystem: Bool {
		return objectForKey(NSLocaleUsesMetricSystem) as? Bool ?? false
	}
}

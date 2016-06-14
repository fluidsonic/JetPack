import Foundation


public extension NSUserDefaults {

	public func dateForKey(defaultName: String) -> NSDate? {
		return objectForKey(defaultName) as? NSDate
	}
}

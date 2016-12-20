import Foundation


public extension UserDefaults {

	public func dateForKey(_ defaultName: String) -> Date? {
		return object(forKey: defaultName) as? Date
	}
}

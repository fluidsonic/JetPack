import Foundation


public extension UserDefaults {

	func dateForKey(_ defaultName: String) -> Date? {
		return object(forKey: defaultName) as? Date
	}
}

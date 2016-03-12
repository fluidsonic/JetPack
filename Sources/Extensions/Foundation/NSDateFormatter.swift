import Foundation


public extension NSDateFormatter {

	@nonobjc
	public static let iso8859Formatter: NSDateFormatter = {
		let formatter = NSDateFormatter()
		formatter.locale = NSLocale.englishUnitedStatesComputer
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
		return formatter
	}()
}

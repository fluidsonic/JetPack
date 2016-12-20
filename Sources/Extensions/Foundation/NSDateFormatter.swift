import Foundation


public extension DateFormatter {

	@nonobjc
	public static let iso8859Formatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.locale = Locale.englishUnitedStatesComputer
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
		return formatter
	}()
}

import Foundation


public extension DateFormatter {

	@nonobjc
	private static let iso8601Formatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.locale = Locale.englishUnitedStatesComputer
		formatter.timeZone = TimeZone(secondsFromGMT: 0)
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"

		return formatter
	}()

	@nonobjc
	private static let iso8601FormatterWithFractionalSeconds: DateFormatter = {
		let formatter = DateFormatter()
		formatter.locale = Locale.englishUnitedStatesComputer
		formatter.timeZone = TimeZone(secondsFromGMT: 0)
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"

		return formatter
	}()

	@available(*, deprecated, message: "use 'iso8601Formatter(withFractionalSeconds: Bool)' instead")
	@nonobjc
	public static let iso8859Formatter: DateFormatter = iso8601Formatter


	@nonobjc
	public static func iso8601Formatter(withFractionalSeconds: Bool = false) -> DateFormatter {
		if withFractionalSeconds {
			return iso8601FormatterWithFractionalSeconds
		}
		
		return iso8601Formatter
	}
}

import Foundation


public extension DateFormatter {

	@available(*, deprecated, message: "use 'iso8601Formatter(withFractionalSeconds: Bool)' instead")
	@nonobjc
	public static let iso8859Formatter: DateFormatter = iso8601Formatter()

	@nonobjc
	public static func iso8601Formatter(withFractionalSeconds: Bool = false) -> DateFormatter {
		let isoFormatter = DateFormatter()
		isoFormatter.locale = Locale.englishUnitedStatesComputer
		if withFractionalSeconds {
			isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
		}
		else {
			isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
		}
		
		return isoFormatter
	}
}

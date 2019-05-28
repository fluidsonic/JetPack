import Foundation


public extension Date {

	@nonobjc
	var iso8601: String {
		return DateFormatter.iso8601Formatter(withFractionalSeconds: true).string(from: self)
	}
}

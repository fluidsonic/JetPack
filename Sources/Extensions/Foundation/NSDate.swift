import Foundation


public extension Date {

	@nonobjc
	public var iso8859: String {
		return DateFormatter.iso8859Formatter.string(from: self)
	}
}

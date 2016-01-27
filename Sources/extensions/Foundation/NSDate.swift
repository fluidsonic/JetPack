import Foundation


public extension NSDate {

	@nonobjc
	public var iso8859: String {
		return NSDateFormatter.iso8859Formatter.stringFromDate(self)
	}
}


extension NSDate: Comparable {}

public func < (a: NSDate, b: NSDate) -> Bool {
	return a.compare(b) == NSComparisonResult.OrderedAscending
}

public func == (a: NSDate, b: NSDate) -> Bool {
	return a.isEqualToDate(b)
}

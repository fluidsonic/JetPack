import Foundation


extension NSDate: Comparable {}

public func < (a: NSDate, b: NSDate) -> Bool {
	return a.compare(b) == NSComparisonResult.OrderedAscending
}

public func == (a: NSDate, b: NSDate) -> Bool {
	return a.isEqualToDate(b)
}

import Foundation


public extension NSDate {

	public func isSameDayAs(otherDate: NSDate) -> Bool {
		let calendar = NSCalendar.currentCalendar()
		let components = calendar.components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear | .CalendarUnitEra, fromDate: self)
		let otherComponents = calendar.components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear | .CalendarUnitEra, fromDate: otherDate)

		return (components.day == otherComponents.day
			&& components.month == otherComponents.month
			&& components.year == otherComponents.year
			&& components.era == otherComponents.era)
	}
}


extension NSDate: Comparable {}

public func < (a: NSDate, b: NSDate) -> Bool {
	return a.compare(b) == NSComparisonResult.OrderedAscending
}

public func == (a: NSDate, b: NSDate) -> Bool {
	return a.isEqualToDate(b)
}

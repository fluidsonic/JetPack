import Foundation


public extension NSDate {

	public func isInSameDayAs(otherDate: NSDate) -> Bool {
		let calendar = NSCalendar.currentCalendar()
		let components = calendar.components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear | .CalendarUnitEra, fromDate: self)
		let otherComponents = calendar.components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear | .CalendarUnitEra, fromDate: otherDate)

		return (components.day == otherComponents.day
			&& components.month == otherComponents.month
			&& components.year == otherComponents.year
			&& components.era == otherComponents.era)
	}


	public var isInToday: Bool {
		return isInSameDayAs(NSDate())
	}


	public var isInTomorrow: Bool {
		let calendar = NSCalendar.currentCalendar()
		if let tomorrow = calendar.dateByAddingUnit(.CalendarUnitDay, value: 1, toDate: NSDate(), options: nil) {
			return isInSameDayAs(tomorrow)
		}

		return false
	}


	public func minus(years: Int? = nil, months: Int? = nil, days: Int? = nil, hours: Int? = nil, minutes: Int? = nil, seconds: Int? = nil, inTimeZone timeZone: NSTimeZone? = nil) -> NSDate? {
		return plus(years: years.map(-), months: months.map(-), days: days.map(-), hours: hours.map(-), minutes: minutes.map(-), seconds: seconds.map(-))
	}


	public func plus(years: Int? = nil, months: Int? = nil, days: Int? = nil, hours: Int? = nil, minutes: Int? = nil, seconds: Int? = nil, inTimeZone timeZone: NSTimeZone? = nil) -> NSDate? {
		let calendar = NSCalendar.currentCalendar()
		if let timeZone = timeZone {
			calendar.timeZone = timeZone
		}

		let components = NSDateComponents()

		if let years = years {
			components.year = years
		}
		if let months = months {
			components.month = months
		}
		if let days = days {
			components.day = days
		}
		if let hours = hours {
			components.hour = hours
		}
		if let minutes = minutes {
			components.minute = minutes
		}
		if let seconds = seconds {
			components.second = seconds
		}

		return calendar.dateByAddingComponents(components, toDate: self, options: nil)
	}


	public func with(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil, inTimeZone timeZone: NSTimeZone? = nil) -> NSDate? {
		let calendar = NSCalendar.currentCalendar()
		if let timeZone = timeZone {
			calendar.timeZone = timeZone
		}

		let components = calendar.components(.All, fromDate: self)

		if let year = year {
			components.year = year
		}
		if let month = month {
			components.month = month
		}
		if let day = day {
			components.day = day
		}
		if let hour = hour {
			components.hour = hour
		}
		if let minute = minute {
			components.minute = minute
		}
		if let second = second {
			components.second = second
		}

		return calendar.dateFromComponents(components)
	}
}


extension NSDate: Comparable {}

public func < (a: NSDate, b: NSDate) -> Bool {
	return a.compare(b) == NSComparisonResult.OrderedAscending
}

public func == (a: NSDate, b: NSDate) -> Bool {
	return a.isEqualToDate(b)
}

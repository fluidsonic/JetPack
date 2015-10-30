import Foundation


public extension NSCalendar {

	@nonobjc
	@warn_unused_result
	public func dateByAdding(seconds seconds: Int? = nil, minutes: Int? = nil, hours: Int? = nil, days: Int? = nil, months: Int? = nil, years: Int? = nil, toDate date: NSDate) -> NSDate? {
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

		return dateByAddingComponents(components, toDate: date, options: [])
	}


	@nonobjc
	@warn_unused_result
	public func dateBySubtracting(seconds seconds: Int? = nil, minutes: Int? = nil, hours: Int? = nil, days: Int? = nil, months: Int? = nil, years: Int? = nil, fromDate date: NSDate) -> NSDate? {
		return dateByAdding(seconds: seconds.map(-), minutes: minutes.map(-), hours: hours.map(-), days: days.map(-), months: months.map(-), years: years.map(-), toDate: date)
	}
}

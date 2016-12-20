import Foundation


public extension Calendar {

	public func dateByAdding(seconds: Int? = nil, minutes: Int? = nil, hours: Int? = nil, days: Int? = nil, months: Int? = nil, years: Int? = nil, toDate date: Date) -> Date? {
		var components = DateComponents()

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

		return self.date(byAdding: components, to: date)
	}


	public func dateBySubtracting(seconds: Int? = nil, minutes: Int? = nil, hours: Int? = nil, days: Int? = nil, months: Int? = nil, years: Int? = nil, fromDate date: Date) -> Date? {
		return dateByAdding(seconds: seconds.map(-), minutes: minutes.map(-), hours: hours.map(-), days: days.map(-), months: months.map(-), years: years.map(-), toDate: date)
	}


	public func firstDateOfWeek(_ date: Date) -> Date? {
		let calendar = self as NSCalendar
		var firstDateOfWeek: NSDate?
		_ = calendar.range(of: .weekOfYear, start: &firstDateOfWeek, interval: nil, for: date)
		return firstDateOfWeek as Date?
	}
}

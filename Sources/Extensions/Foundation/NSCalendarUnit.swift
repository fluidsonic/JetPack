import Foundation


public extension NSCalendar.Unit {

	@nonobjc
	static let all: NSCalendar.Unit = [
		.era,
		.year,
		.month,
		.day,
		.hour,
		.minute,
		.second,
		.weekday,
		.weekdayOrdinal,
		.weekOfMonth,
		.weekOfYear,
		.yearForWeekOfYear,
		.nanosecond,
		.calendar,
		.timeZone
	]
}

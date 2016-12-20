import Foundation


public extension NSCalendar.Unit {

	@nonobjc
	public static let All: NSCalendar.Unit = [
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

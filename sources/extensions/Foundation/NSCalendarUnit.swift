import Foundation


public extension NSCalendarUnit {

	// prefixed all values with "NSCalendarUnit." instead of "." since it speeds up the file's compile time significantly
	public static let All: NSCalendarUnit =
		NSCalendarUnit.CalendarUnitEra |
		NSCalendarUnit.CalendarUnitYear |
		NSCalendarUnit.CalendarUnitMonth |
		NSCalendarUnit.CalendarUnitDay |
		NSCalendarUnit.CalendarUnitHour |
		NSCalendarUnit.CalendarUnitMinute |
		NSCalendarUnit.CalendarUnitSecond |
		NSCalendarUnit.CalendarUnitWeekday |
		NSCalendarUnit.CalendarUnitWeekdayOrdinal |
		NSCalendarUnit.CalendarUnitWeekOfMonth |
		NSCalendarUnit.CalendarUnitWeekOfYear |
		NSCalendarUnit.CalendarUnitYearForWeekOfYear |
		NSCalendarUnit.CalendarUnitNanosecond |
		NSCalendarUnit.CalendarUnitCalendar |
		NSCalendarUnit.CalendarUnitTimeZone
}

import XCTest

import Foundation
import JetPack


class NSCalendarUnit_Tests: XCTestCase {

	func testShortcutProperties() {
		let all: NSCalendar.Unit  = [.era, .year, .month, .day, .hour, .minute, .second, .weekday, .weekdayOrdinal, .weekOfMonth, .weekOfYear, .yearForWeekOfYear, .nanosecond, .calendar, .timeZone]
		XCTAssertEqual(NSCalendar.Unit.All, all)
	}
}

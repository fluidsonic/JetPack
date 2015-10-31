import XCTest

import Foundation
import JetPack


class NSCalendarUnit_Tests: XCTestCase {

	func testShortcutProperties() {
		let all: NSCalendarUnit  = [.Era, .Year, .Month, .Day, .Hour, .Minute, .Second, .Weekday, .WeekdayOrdinal, .WeekOfMonth, .WeekOfYear, .YearForWeekOfYear, .Nanosecond, .Calendar, .TimeZone]
		XCTAssertEqual(NSCalendarUnit.All, all)
	}
}

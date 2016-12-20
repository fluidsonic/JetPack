import XCTest

import Foundation
import JetPack


class NSCalendar_Tests: XCTestCase {

	fileprivate let calendar = Calendar(identifier: Calendar.Identifier.gregorian)


	fileprivate func dateWithYear(_ year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> Date {
		var components = DateComponents()
		components.year = year
		components.month = month
		components.day = day
		components.hour = hour
		components.minute = minute
		components.second = second

		return calendar.date(from: components)!
	}


	func testDateByAdding() {
		let date = dateWithYear(2000, month: 1, day: 1, hour: 0, minute: 0, second: 0)
		XCTAssertEqual(calendar.dateByAdding(years:   1, toDate: date), dateWithYear(2001, month: 1, day: 1, hour: 0, minute: 0, second: 0))
		XCTAssertEqual(calendar.dateByAdding(months:  1, toDate: date), dateWithYear(2000, month: 2, day: 1, hour: 0, minute: 0, second: 0))
		XCTAssertEqual(calendar.dateByAdding(days:    1, toDate: date), dateWithYear(2000, month: 1, day: 2, hour: 0, minute: 0, second: 0))
		XCTAssertEqual(calendar.dateByAdding(hours:   1, toDate: date), dateWithYear(2000, month: 1, day: 1, hour: 1, minute: 0, second: 0))
		XCTAssertEqual(calendar.dateByAdding(minutes: 1, toDate: date), dateWithYear(2000, month: 1, day: 1, hour: 0, minute: 1, second: 0))
		XCTAssertEqual(calendar.dateByAdding(seconds: 1, toDate: date), dateWithYear(2000, month: 1, day: 1, hour: 0, minute: 0, second: 1))

		XCTAssertEqual(
			calendar.dateByAdding(seconds: 1, minutes: 1, hours: 1, days: 1, months: 1, years: 1, toDate: date),
			dateWithYear(2001, month: 2, day: 2, hour: 1, minute: 1, second: 1)
		)
	}


	func testDateBySubtracting() {
		let date = dateWithYear(2001, month: 2, day: 2, hour: 1, minute: 1, second: 1)
		XCTAssertEqual(calendar.dateBySubtracting(years:   1, fromDate: date), dateWithYear(2000, month: 2, day: 2, hour: 1, minute: 1, second: 1))
		XCTAssertEqual(calendar.dateBySubtracting(months:  1, fromDate: date), dateWithYear(2001, month: 1, day: 2, hour: 1, minute: 1, second: 1))
		XCTAssertEqual(calendar.dateBySubtracting(days:    1, fromDate: date), dateWithYear(2001, month: 2, day: 1, hour: 1, minute: 1, second: 1))
		XCTAssertEqual(calendar.dateBySubtracting(hours:   1, fromDate: date), dateWithYear(2001, month: 2, day: 2, hour: 0, minute: 1, second: 1))
		XCTAssertEqual(calendar.dateBySubtracting(minutes: 1, fromDate: date), dateWithYear(2001, month: 2, day: 2, hour: 1, minute: 0, second: 1))
		XCTAssertEqual(calendar.dateBySubtracting(seconds: 1, fromDate: date), dateWithYear(2001, month: 2, day: 2, hour: 1, minute: 1, second: 0))

		XCTAssertEqual(
			calendar.dateBySubtracting(seconds: 1, minutes: 1, hours: 1, days: 1, months: 1, years: 1, fromDate: date),
			dateWithYear(2000, month: 1, day: 1, hour: 0, minute: 0, second: 0)
		)
	}
}

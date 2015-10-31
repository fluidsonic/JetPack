import XCTest

import Foundation
import JetPack


class NSDate_Tests: XCTestCase {

	func testComparable() {
		let earlierDate = NSDate(timeIntervalSince1970: 0)
		let laterDate = NSDate(timeIntervalSince1970: 1)

		XCTAssertTrue (earlierDate <  laterDate)
		XCTAssertTrue (earlierDate <= laterDate)
		XCTAssertFalse(earlierDate == laterDate)
		XCTAssertFalse(earlierDate >= laterDate)
		XCTAssertFalse(earlierDate >  laterDate)

		XCTAssertFalse(laterDate <  earlierDate)
		XCTAssertFalse(laterDate <= earlierDate)
		XCTAssertFalse(laterDate == earlierDate)
		XCTAssertTrue (laterDate >= earlierDate)
		XCTAssertTrue (laterDate >  earlierDate)

		XCTAssertFalse(earlierDate <  earlierDate)
		XCTAssertTrue (earlierDate <= earlierDate)
		XCTAssertTrue (earlierDate == earlierDate)
		XCTAssertTrue (earlierDate >= earlierDate)
		XCTAssertFalse(earlierDate >  earlierDate)
	}
}

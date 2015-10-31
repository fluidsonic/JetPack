import XCTest

import Foundation
import JetPack


class NSLocale_Tests: XCTestCase {

	func testUses24HourFormat() {
		XCTAssertEqual(NSLocale(localeIdentifier: "en-US").uses24HourFormat, false)
		XCTAssertEqual(NSLocale(localeIdentifier: "de-DE").uses24HourFormat, true)
	}


	func testUsesMetricSystem() {
		XCTAssertEqual(NSLocale(localeIdentifier: "en-US").usesMetricSystem, false)
		XCTAssertEqual(NSLocale(localeIdentifier: "de-DE").usesMetricSystem, true)
	}
}

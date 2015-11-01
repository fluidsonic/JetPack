import XCTest

import JetPack


class Range_Tests: XCTestCase {

	func testRandomIndex() {
		XCTAssertEqual((0 ..< 0).randomElement, nil)
		XCTAssertEqual((0 ..< 1).randomElement, 0)
	}
}

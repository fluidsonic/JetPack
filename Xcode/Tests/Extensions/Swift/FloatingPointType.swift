import XCTest

import JetPack


class FloatingPointType_Tests: XCTestCase {

	func testSign() {
		XCTAssertEqual(Double(-2).sign, -1)
		XCTAssertEqual(Double( 0).sign,  0)
		XCTAssertEqual(Double( 2).sign,  1)
	}
}

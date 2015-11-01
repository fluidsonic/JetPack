import XCTest

import JetPack


class FloatingPointType_Tests: XCTestCase {

	func testClamp() {
		XCTAssertEqual(Double(1).clamp(min: 0, max: 0), 0)
		XCTAssertEqual(Double(1).clamp(min: 0, max: 2), 1)
		XCTAssertEqual(Double(1).clamp(min: 2, max: 2), 2)
	}


	func testSign() {
		XCTAssertEqual(Double(-2).sign, -1)
		XCTAssertEqual(Double( 0).sign,  0)
		XCTAssertEqual(Double( 2).sign,  1)
	}
}

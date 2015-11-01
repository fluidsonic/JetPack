import XCTest

import JetPack


class IntegerType_Tests: XCTestCase {

	func testClamp() {
		XCTAssertEqual(Int(1).clamp(min: 0, max: 0), 0)
		XCTAssertEqual(Int(1).clamp(min: 0, max: 2), 1)
		XCTAssertEqual(Int(1).clamp(min: 2, max: 2), 2)
	}


	func testSign() {
		XCTAssertEqual(Int(-2).sign, -1)
		XCTAssertEqual(Int( 0).sign,  0)
		XCTAssertEqual(Int( 2).sign,  1)
	}
}

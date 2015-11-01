import XCTest

import JetPack


class AbsoluteValuable_Tests: XCTestCase {

	func testAbsolute() {
		XCTAssertEqual(Float(-1).absolute,  1)
		XCTAssertEqual(Float( 1).absolute,  1)
		XCTAssertEqual(Double(-1).absolute, 1)
		XCTAssertEqual(Double( 1).absolute, 1)
	}
}

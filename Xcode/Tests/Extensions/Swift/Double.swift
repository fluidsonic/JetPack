import XCTest

import Darwin
import JetPack


class Double_Tests: XCTestCase {

	func testConstants() {
		XCTAssertEqual(Double.Epsilon, Double(DBL_EPSILON))
		XCTAssertEqual(Double.Pi,      3.1415926535897932384626433832)
	}


	func testRound() {
		XCTAssertEqual(Double(-0.9).round, -1)
		XCTAssertEqual(Double(-0.5).round, -1)
		XCTAssertEqual(Double(-0.1).round,  0)
		XCTAssertEqual(Double( 0.0).round,  0)
		XCTAssertEqual(Double( 0.1).round,  0)
		XCTAssertEqual(Double( 0.5).round,  1)
		XCTAssertEqual(Double( 0.9).round,  1)
	}
}

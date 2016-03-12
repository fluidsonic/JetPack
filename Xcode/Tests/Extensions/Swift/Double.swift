import XCTest

import Darwin
import JetPack


class Double_Tests: XCTestCase {

	func testConstants() {
		XCTAssertEqual(Double.Epsilon, Double(DBL_EPSILON))
		XCTAssertEqual(Double.Pi,      3.1415926535897932384626433832)
	}


	func testRounded() {
		XCTAssertEqual(Double(-0.9).rounded, -1)
		XCTAssertEqual(Double(-0.5).rounded, -1)
		XCTAssertEqual(Double(-0.1).rounded,  0)
		XCTAssertEqual(Double( 0.0).rounded,  0)
		XCTAssertEqual(Double( 0.1).rounded,  0)
		XCTAssertEqual(Double( 0.5).rounded,  1)
		XCTAssertEqual(Double( 0.9).rounded,  1)
	}


	func testRoundedDown() {
		XCTAssertEqual(Double(-0.9).roundedDown, -1)
		XCTAssertEqual(Double(-0.5).roundedDown, -1)
		XCTAssertEqual(Double(-0.1).roundedDown, -1)
		XCTAssertEqual(Double( 0.0).roundedDown,  0)
		XCTAssertEqual(Double( 0.1).roundedDown,  0)
		XCTAssertEqual(Double( 0.5).roundedDown,  0)
		XCTAssertEqual(Double( 0.9).roundedDown,  0)
	}


	func testRoundedUp() {
		XCTAssertEqual(Double(-0.9).roundedUp, 0)
		XCTAssertEqual(Double(-0.5).roundedUp, 0)
		XCTAssertEqual(Double(-0.1).roundedUp, 0)
		XCTAssertEqual(Double( 0.0).roundedUp, 0)
		XCTAssertEqual(Double( 0.1).roundedUp, 1)
		XCTAssertEqual(Double( 0.5).roundedUp, 1)
	}
}

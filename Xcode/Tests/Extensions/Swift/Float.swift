import XCTest

import Darwin
import JetPack


class Float_Tests: XCTestCase {

	func testConstants() {
		XCTAssertEqual(Float.Epsilon, Float(FLT_EPSILON))
		XCTAssertEqual(Float.Pi,      Float(3.1415926535897932384626433832))
	}


	func testRound() {
		XCTAssertEqual(Float(-0.9).round, -1)
		XCTAssertEqual(Float(-0.5).round, -1)
		XCTAssertEqual(Float(-0.1).round,  0)
		XCTAssertEqual(Float( 0.0).round,  0)
		XCTAssertEqual(Float( 0.1).round,  0)
		XCTAssertEqual(Float( 0.5).round,  1)
		XCTAssertEqual(Float( 0.9).round,  1)
	}
}

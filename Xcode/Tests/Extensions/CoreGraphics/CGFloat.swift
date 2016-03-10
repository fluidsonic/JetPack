import XCTest

import CoreGraphics
import JetPack


class CGFloat_Tests: XCTestCase {

	func testConstants() {
		XCTAssertEqual(CGFloat.Epsilon, CGFloat(CGFloat.NativeType.Epsilon))
		XCTAssertEqual(CGFloat.Pi,      CGFloat(3.1415926535897932384626433832))
	}


	func testRounded() {
		XCTAssertEqual(CGFloat(-0.9).rounded, -1)
		XCTAssertEqual(CGFloat(-0.5).rounded, -1)
		XCTAssertEqual(CGFloat(-0.1).rounded,  0)
		XCTAssertEqual(CGFloat( 0.0).rounded,  0)
		XCTAssertEqual(CGFloat( 0.1).rounded,  0)
		XCTAssertEqual(CGFloat( 0.5).rounded,  1)
		XCTAssertEqual(CGFloat( 0.9).rounded,  1)
	}


	func testRoundedDown() {
		XCTAssertEqual(CGFloat(-0.9).roundedDown, -1)
		XCTAssertEqual(CGFloat(-0.5).roundedDown, -1)
		XCTAssertEqual(CGFloat(-0.1).roundedDown, -1)
		XCTAssertEqual(CGFloat( 0.0).roundedDown,  0)
		XCTAssertEqual(CGFloat( 0.1).roundedDown,  0)
		XCTAssertEqual(CGFloat( 0.5).roundedDown,  0)
		XCTAssertEqual(CGFloat( 0.9).roundedDown,  0)
	}


	func testRoundedUp() {
		XCTAssertEqual(CGFloat(-0.9).roundedUp, 0)
		XCTAssertEqual(CGFloat(-0.5).roundedUp, 0)
		XCTAssertEqual(CGFloat(-0.1).roundedUp, 0)
		XCTAssertEqual(CGFloat( 0.0).roundedUp, 0)
		XCTAssertEqual(CGFloat( 0.1).roundedUp, 1)
		XCTAssertEqual(CGFloat( 0.5).roundedUp, 1)
		XCTAssertEqual(CGFloat( 0.9).roundedUp, 1)
	}
}

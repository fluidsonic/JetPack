import XCTest

import CoreGraphics
import JetPack


class CGFloat_Tests: XCTestCase {

	func testConstants() {
		XCTAssertEqual(CGFloat.Epsilon, CGFloat(CGFloat.NativeType.Epsilon))
		XCTAssertEqual(CGFloat.Pi,      CGFloat(3.1415926535897932384626433832))
	}


	func testRound() {
		XCTAssertEqual(CGFloat(-0.9).round, -1)
		XCTAssertEqual(CGFloat(-0.5).round, -1)
		XCTAssertEqual(CGFloat(-0.1).round,  0)
		XCTAssertEqual(CGFloat( 0.0).round,  0)
		XCTAssertEqual(CGFloat( 0.1).round,  0)
		XCTAssertEqual(CGFloat( 0.5).round,  1)
		XCTAssertEqual(CGFloat( 0.9).round,  1)
	}
}

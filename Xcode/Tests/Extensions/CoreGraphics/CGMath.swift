import XCTest

@testable import JetPack


class CGMath_Tests: XCTestCase {

	func testConstants() {
		XCTAssertEqual(CGMath.radiansRight,  0)
		XCTAssertEqual(CGMath.radiansBottom, CGFloat.Pi / 2)
		XCTAssertEqual(CGMath.radiansLeft,   CGFloat.Pi)
		XCTAssertEqual(CGMath.radiansTop,    (3 * CGFloat.Pi) / 2)
	}
}

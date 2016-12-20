import XCTest

import CoreGraphics
@testable import JetPack


class CGMath_Tests: XCTestCase {

	func testConstants() {
		XCTAssertEqual(CGMath.radiansRight,  0)
		XCTAssertEqual(CGMath.radiansBottom, CGFloat.pi / 2)
		XCTAssertEqual(CGMath.radiansLeft,   CGFloat.pi)
		XCTAssertEqual(CGMath.radiansTop,    (3 * CGFloat.pi) / 2)
	}
}

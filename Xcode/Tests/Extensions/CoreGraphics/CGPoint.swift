import XCTest

import CoreGraphics
import JetPack


class CGPoint_Tests: XCTestCase {

	func testCoerced() {
		XCTAssertEqual(CGPoint(x: 1, y: 2).coerced(min: CGPoint(x: 0, y: 1), max: CGPoint(x: 0, y: 1)), CGPoint(x: 0, y: 1))
		XCTAssertEqual(CGPoint(x: 1, y: 2).coerced(min: CGPoint(x: 0, y: 1), max: CGPoint(x: 2, y: 3)), CGPoint(x: 1, y: 2))
		XCTAssertEqual(CGPoint(x: 1, y: 2).coerced(min: CGPoint(x: 2, y: 3), max: CGPoint(x: 2, y: 3)), CGPoint(x: 2, y: 3))
	}


	func testDisplacement() {
		let point = CGPoint(x: 0, y: 1)
		XCTAssertEqual(point.displacement(to: CGPoint(x: 2, y: 3)), CGPoint(x: 2, y: 2))
	}


	func testDistance() {
		let point = CGPoint(x: 1, y: 2)
		XCTAssertEqualWithAccuracy(point.distance(to: CGPoint(x: 3, y: 4)), 2.8284271247461900976033774484193961571, accuracy: CGFloat(FLT_EPSILON))
	}

	
	func testInit() {
		XCTAssertEqual(CGPoint(left: 1, top: 2), CGPoint(x: 1, y: 2))
	}


	func testOffset() {
		let point = CGPoint(x: 1, y: 2)
		XCTAssertEqual(point.offsetBy(dx: 3),               CGPoint(x: 4, y: 2))
		XCTAssertEqual(point.offsetBy(dy: 4),               CGPoint(x: 1, y: 6))
		XCTAssertEqual(point.offsetBy(dx: 3, dy: 4),        CGPoint(x: 4, y: 6))
		XCTAssertEqual(point.offsetBy(CGPoint(x: 3, y: 4)), CGPoint(x: 4, y: 6))
		XCTAssertEqual(point, CGPoint(x: 1, y: 2))
	}


	func testShortcutProperties() {
		let point = CGPoint(x: 1, y: 2)
		XCTAssertEqual(point.left, 1)
		XCTAssertEqual(point.top,  2)
	}
}

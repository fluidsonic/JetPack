import XCTest

import CoreGraphics
import JetPack


class CGSize_Tests: XCTestCase {

	func testConstants() {
		XCTAssertEqual(CGSize.max, CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
	}


	func testConstrain() {
		let size = CGSize(width: 3, height: 4)
		XCTAssertEqual(size.constrainTo(CGSize(width: 1, height: 2)), CGSize(width: 1, height: 2))
		XCTAssertEqual(size.constrainTo(CGSize(width: 4, height: 5)), size)

		var mutableSize = size
		mutableSize.constrainInPlace(CGSize(width: 1, height: 2))
		XCTAssertEqual(mutableSize, CGSize(width: 1, height: 2))

		mutableSize = size
		mutableSize.constrainInPlace(CGSize(width: 4, height: 5))
		XCTAssertEqual(mutableSize, size)
	}


	func testInit() {
		XCTAssertEqual(CGSize(square: 1), CGSize(width: 1, height: 1))
	}


	func testShortcutProperties() {
		let size = CGSize(width: 2, height: 4)
		XCTAssertEqual(size.center, CGPoint(x: 1, y: 2))

		XCTAssertEqual(CGSize(width: -1, height: -1).isEmpty, false)
		XCTAssertEqual(CGSize(width:  0, height:  0).isEmpty,  true)
		XCTAssertEqual(CGSize(width:  1, height:  1).isEmpty, false)
	}


	func testScale() {
		let size = CGSize(width: 2, height: 4)
		XCTAssertEqual(size.scaleBy(2), CGSize(width: 4, height: 8))

		var mutableSize = size
		mutableSize.scaleInPlace(2)
		XCTAssertEqual(mutableSize, CGSize(width: 4, height: 8))
	}


	func testTransform() {
		let size = CGSize(width: 2, height: 4)
		XCTAssertEqual(size.transform(CGAffineTransform(scaleX: 2, y: 2)), CGSize(width: 4, height: 8))

		var mutableSize = size
		mutableSize.transformInPlace(CGAffineTransform(scaleX: 2, y: 2))
		XCTAssertEqual(mutableSize, CGSize(width: 4, height: 8))
	}
}

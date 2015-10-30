import XCTest

import CoreGraphics
import JetPack


class CGRect_Tests: XCTestCase {

	func testInit() {
		XCTAssertEqual(CGRect(size: CGSize(width: 1, height: 2)), CGRect(x: 0, y: 0, width: 1, height: 2))
		XCTAssertEqual(CGRect(left: 0, top: 1, width: 2, height: 3), CGRect(x: 0, y: 1, width: 2, height: 3))
		XCTAssertEqual(CGRect(width: 1, height: 2), CGRect(x: 0, y: 0, width: 1, height: 2))
	}


	func testShortcutProperties() {
		let rect = CGRect(x: 0, y: 1, width: 2, height: 3)
		XCTAssertEqual(rect.bottom,           4)
		XCTAssertEqual(rect.bottomLeft,       CGPoint(x: 0, y: 4))
		XCTAssertEqual(rect.bottomRight,      CGPoint(x: 2, y: 4))
		XCTAssertEqual(rect.center,           CGPoint(x: 1, y: 2.5))
		XCTAssertEqual(rect.height,           3)
		XCTAssertEqual(rect.horizontalCenter, 1)
		XCTAssertEqual(rect.left,             0)
		XCTAssertEqual(rect.right,            2)
		XCTAssertEqual(rect.top,              1)
		XCTAssertEqual(rect.topLeft,          CGPoint(x: 0, y: 1))
		XCTAssertEqual(rect.topRight,         CGPoint(x: 2, y: 1))
		XCTAssertEqual(rect.verticalCenter,   2.5)
		XCTAssertEqual(rect.width,            2)

		var mutableRect = rect
		mutableRect.bottom = 5
		XCTAssertEqual(mutableRect, CGRect(x: 0, y: 2, width: 2, height: 3))

		mutableRect = rect
		mutableRect.bottomLeft = CGPoint(x: 1, y: 5)
		XCTAssertEqual(mutableRect, CGRect(x: 1, y: 2, width: 2, height: 3))

		mutableRect = rect
		mutableRect.bottomRight = CGPoint(x: 3, y: 5)
		XCTAssertEqual(mutableRect, CGRect(x: 1, y: 2, width: 2, height: 3))

		mutableRect = rect
		mutableRect.center = CGPoint(x: 2, y: 3.5)
		XCTAssertEqual(mutableRect, CGRect(x: 1, y: 2, width: 2, height: 3))

		/* // cannot test due to Swift limitation
		mutableRect = rect
		mutableRect.height = 4
		XCTAssertEqual(mutableRect, CGRect(x: 0, y: 1, width: 2, height: 4))
		*/

		mutableRect = rect
		mutableRect.horizontalCenter = 2
		XCTAssertEqual(mutableRect, CGRect(x: 1, y: 1, width: 2, height: 3))

		mutableRect = rect
		mutableRect.left = 1
		XCTAssertEqual(mutableRect, CGRect(x: 1, y: 1, width: 2, height: 3))

		mutableRect = rect
		mutableRect.right = 3
		XCTAssertEqual(mutableRect, CGRect(x: 1, y: 1, width: 2, height: 3))

		mutableRect = rect
		mutableRect.top = 2
		XCTAssertEqual(mutableRect, CGRect(x: 0, y: 2, width: 2, height: 3))

		mutableRect = rect
		mutableRect.topLeft = CGPoint(x: 1, y: 2)
		XCTAssertEqual(mutableRect, CGRect(x: 1, y: 2, width: 2, height: 3))

		mutableRect = rect
		mutableRect.topRight = CGPoint(x: 3, y: 2)
		XCTAssertEqual(mutableRect, CGRect(x: 1, y: 2, width: 2, height: 3))

		mutableRect = rect
		mutableRect.verticalCenter = 3.5
		XCTAssertEqual(mutableRect, CGRect(x: 0, y: 2, width: 2, height: 3))

		/* // cannot test due to Swift limitation
		mutableRect = rect
		mutableRect.width = 3
		XCTAssertEqual(mutableRect, CGRect(x: 0, y: 1, width: 3, height: 3))
		*/
	}


	func testContains() {
		let hitRect = CGRect(x: 5, y: 10, width: 20, height: 30)
		let insideRect = hitRect.insetBy(dx: 1, dy: 1)
		let outsideRect = hitRect.insetBy(dx: -1, dy: -1)

		XCTAssertEqual(hitRect.contains(insideRect.topLeft,      atCornerRadius: 0), true)
		XCTAssertEqual(hitRect.contains(insideRect.topRight,     atCornerRadius: 0), true)
		XCTAssertEqual(hitRect.contains(insideRect.bottomLeft,   atCornerRadius: 0), true)
		XCTAssertEqual(hitRect.contains(insideRect.bottomRight,  atCornerRadius: 0), true)
		XCTAssertEqual(hitRect.contains(insideRect.center,       atCornerRadius: 0), true)
		XCTAssertEqual(hitRect.contains(outsideRect.topLeft,     atCornerRadius: 0), false)
		XCTAssertEqual(hitRect.contains(outsideRect.topRight,    atCornerRadius: 0), false)
		XCTAssertEqual(hitRect.contains(outsideRect.bottomLeft,  atCornerRadius: 0), false)
		XCTAssertEqual(hitRect.contains(outsideRect.bottomRight, atCornerRadius: 0), false)
		XCTAssertEqual(hitRect.contains(insideRect.topLeft,      atCornerRadius: 5), false)
		XCTAssertEqual(hitRect.contains(insideRect.topRight,     atCornerRadius: 5), false)
		XCTAssertEqual(hitRect.contains(insideRect.bottomLeft,   atCornerRadius: 5), false)
		XCTAssertEqual(hitRect.contains(insideRect.bottomRight,  atCornerRadius: 5), false)
		XCTAssertEqual(hitRect.contains(insideRect.center,       atCornerRadius: 5), true)
		XCTAssertEqual(hitRect.contains(outsideRect.topLeft,     atCornerRadius: 5), false)
		XCTAssertEqual(hitRect.contains(outsideRect.topRight,    atCornerRadius: 5), false)
		XCTAssertEqual(hitRect.contains(outsideRect.bottomLeft,  atCornerRadius: 5), false)
		XCTAssertEqual(hitRect.contains(outsideRect.bottomRight, atCornerRadius: 5), false)
	}


	func testInterpolate() {
		let fromRect = CGRect(x: 0, y: 1, width: 10, height: 20)
		let toRect   = CGRect(x: 5, y: 6, width: 15, height: 25)

		XCTAssertEqual(fromRect.interpolateTo(toRect, fraction: -1),   CGRect(x: -5, y: -4, width: 5, height: 15))
		XCTAssertEqual(fromRect.interpolateTo(toRect, fraction:  0),   fromRect)
		XCTAssertEqual(fromRect.interpolateTo(toRect, fraction:  0.5), CGRect(x: 2.5, y: 3.5, width: 12.5, height: 22.5))
		XCTAssertEqual(fromRect.interpolateTo(toRect, fraction:  1),   toRect)
		XCTAssertEqual(fromRect.interpolateTo(toRect, fraction:  2),   CGRect(x: 10, y: 11, width: 20, height: 30))
	}


	func testTransform() {
		let rect = CGRect(x: 1, y: 2, width: 3, height: 4)
		XCTAssertEqual(rect.transform(CGAffineTransformMakeTranslation(1, 2)), CGRect(x: 2, y: 4, width: 3, height: 4))

		var mutableRect = rect
		mutableRect.transformInPlace(CGAffineTransformMakeTranslation(1, 2))
		XCTAssertEqual(mutableRect, CGRect(x: 2, y: 4, width: 3, height: 4))
	}
}

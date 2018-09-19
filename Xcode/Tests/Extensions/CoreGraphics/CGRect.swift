import XCTest

import CoreGraphics
import JetPack


class CGRect_Tests: XCTestCase {

	func testInit() {
		XCTAssertEqual(CGRect(size: CGSize(width: 1, height: 2)), CGRect(x: 0, y: 0, width: 1, height: 2))
		XCTAssertEqual(CGRect(left: 0, top: 1, width: 2, height: 3), CGRect(x: 0, y: 1, width: 2, height: 3))
		XCTAssertEqual(CGRect(width: 1, height: 2), CGRect(x: 0, y: 0, width: 1, height: 2))
	}


	func testContains() {
		let hitRect = CGRect(x: 5, y: 10, width: 20, height: 30)
		let insideRect = hitRect.insetBy(dx: 1, dy: 1)
		let outsideRect = hitRect.insetBy(dx: -1, dy: -1)

		XCTAssertEqual(hitRect.contains(insideRect.topLeft,       cornerRadius: 0), true)
		XCTAssertEqual(hitRect.contains(insideRect.topCenter,     cornerRadius: 0), true)
		XCTAssertEqual(hitRect.contains(insideRect.topRight,      cornerRadius: 0), true)
		XCTAssertEqual(hitRect.contains(insideRect.bottomLeft,    cornerRadius: 0), true)
		XCTAssertEqual(hitRect.contains(insideRect.bottomCenter,  cornerRadius: 0), true)
		XCTAssertEqual(hitRect.contains(insideRect.bottomRight,   cornerRadius: 0), true)
		XCTAssertEqual(hitRect.contains(insideRect.center,        cornerRadius: 0), true)
		XCTAssertEqual(hitRect.contains(insideRect.centerLeft,    cornerRadius: 0), true)
		XCTAssertEqual(hitRect.contains(insideRect.centerRight,   cornerRadius: 0), true)
		XCTAssertEqual(hitRect.contains(outsideRect.topLeft,      cornerRadius: 0), false)
		XCTAssertEqual(hitRect.contains(outsideRect.topCenter,    cornerRadius: 0), false)
		XCTAssertEqual(hitRect.contains(outsideRect.topRight,     cornerRadius: 0), false)
		XCTAssertEqual(hitRect.contains(outsideRect.bottomLeft,   cornerRadius: 0), false)
		XCTAssertEqual(hitRect.contains(outsideRect.bottomCenter, cornerRadius: 0), false)
		XCTAssertEqual(hitRect.contains(outsideRect.bottomRight,  cornerRadius: 0), false)
		XCTAssertEqual(hitRect.contains(outsideRect.centerLeft,   cornerRadius: 0), false)
		XCTAssertEqual(hitRect.contains(outsideRect.centerRight,  cornerRadius: 0), false)
		XCTAssertEqual(hitRect.contains(insideRect.topLeft,       cornerRadius: 5), false)
		XCTAssertEqual(hitRect.contains(insideRect.topCenter,     cornerRadius: 5), true)
		XCTAssertEqual(hitRect.contains(insideRect.topRight,      cornerRadius: 5), false)
		XCTAssertEqual(hitRect.contains(insideRect.bottomLeft,    cornerRadius: 5), false)
		XCTAssertEqual(hitRect.contains(insideRect.bottomCenter,  cornerRadius: 5), true)
		XCTAssertEqual(hitRect.contains(insideRect.bottomRight,   cornerRadius: 5), false)
		XCTAssertEqual(hitRect.contains(insideRect.center,        cornerRadius: 5), true)
		XCTAssertEqual(hitRect.contains(insideRect.centerLeft,    cornerRadius: 5), true)
		XCTAssertEqual(hitRect.contains(insideRect.centerRight,   cornerRadius: 5), true)
		XCTAssertEqual(hitRect.contains(outsideRect.topLeft,      cornerRadius: 5), false)
		XCTAssertEqual(hitRect.contains(outsideRect.topCenter,    cornerRadius: 5), false)
		XCTAssertEqual(hitRect.contains(outsideRect.topRight,     cornerRadius: 5), false)
		XCTAssertEqual(hitRect.contains(outsideRect.bottomLeft,   cornerRadius: 5), false)
		XCTAssertEqual(hitRect.contains(outsideRect.bottomCenter, cornerRadius: 5), false)
		XCTAssertEqual(hitRect.contains(outsideRect.bottomRight,  cornerRadius: 5), false)
		XCTAssertEqual(hitRect.contains(outsideRect.centerLeft,   cornerRadius: 5), false)
		XCTAssertEqual(hitRect.contains(outsideRect.centerRight,  cornerRadius: 5), false)
	}


	func testDisplacement() {
		XCTAssertEqual(CGRect(x: 0, y: 2, width: 2, height: 4).displacement(to: CGPoint(x: -1, y: 1)), CGPoint(x: -1, y: -1))
		XCTAssertEqual(CGRect(x: 0, y: 2, width: 2, height: 4).displacement(to: CGPoint(x:  1, y: 1)), CGPoint(x:  0, y: -1))
		XCTAssertEqual(CGRect(x: 0, y: 2, width: 2, height: 4).displacement(to: CGPoint(x:  3, y: 1)), CGPoint(x:  1, y: -1))
		XCTAssertEqual(CGRect(x: 0, y: 2, width: 2, height: 4).displacement(to: CGPoint(x: -1, y: 3)), CGPoint(x: -1, y:  0))
		XCTAssertEqual(CGRect(x: 0, y: 2, width: 2, height: 4).displacement(to: CGPoint(x:  1, y: 3)), CGPoint(x:  0, y:  0))
		XCTAssertEqual(CGRect(x: 0, y: 2, width: 2, height: 4).displacement(to: CGPoint(x:  3, y: 3)), CGPoint(x:  1, y:  0))
		XCTAssertEqual(CGRect(x: 0, y: 2, width: 2, height: 4).displacement(to: CGPoint(x: -1, y: 7)), CGPoint(x: -1, y:  1))
		XCTAssertEqual(CGRect(x: 0, y: 2, width: 2, height: 4).displacement(to: CGPoint(x:  1, y: 7)), CGPoint(x:  0, y:  1))
		XCTAssertEqual(CGRect(x: 0, y: 2, width: 2, height: 4).displacement(to: CGPoint(x:  3, y: 7)), CGPoint(x:  1, y:  1))
	}


	func testDistance() {
		XCTAssertEqual(CGRect(x: 0, y: 0, width: 1, height: 2).distance(to: CGPoint(x: 3, y: 4)), 2.8284271247461900976033774484193961571, accuracy: .ulpOfOne)
	}


	func testInterpolate() {
		let fromRect = CGRect(x: 0, y: 1, width: 10, height: 20)
		let toRect   = CGRect(x: 5, y: 6, width: 15, height: 25)

		XCTAssertEqual(fromRect.interpolate(to: toRect, fraction: -1),   CGRect(x: -5, y: -4, width: 5, height: 15))
		XCTAssertEqual(fromRect.interpolate(to: toRect, fraction:  0),   fromRect)
		XCTAssertEqual(fromRect.interpolate(to: toRect, fraction:  0.5), CGRect(x: 2.5, y: 3.5, width: 12.5, height: 22.5))
		XCTAssertEqual(fromRect.interpolate(to: toRect, fraction:  1),   toRect)
		XCTAssertEqual(fromRect.interpolate(to: toRect, fraction:  2),   CGRect(x: 10, y: 11, width: 20, height: 30))
	}


	func testShortcutProperties() {
		let rect = CGRect(x: 0, y: 1, width: 2, height: 3)
		XCTAssertEqual(rect.bottom,           4)
		XCTAssertEqual(rect.bottomLeft,       CGPoint(x: 0, y: 4))
		XCTAssertEqual(rect.bottomCenter,     CGPoint(x: 1, y: 4))
		XCTAssertEqual(rect.bottomRight,      CGPoint(x: 2, y: 4))
		XCTAssertEqual(rect.centerLeft,       CGPoint(x: 0, y: 2.5))
		XCTAssertEqual(rect.center,           CGPoint(x: 1, y: 2.5))
		XCTAssertEqual(rect.centerRight,      CGPoint(x: 2, y: 2.5))
		XCTAssertEqual(rect.height,           3)
		XCTAssertEqual(rect.horizontalCenter, 1)
		XCTAssertEqual(rect.left,             0)
		XCTAssertEqual(rect.right,            2)
		XCTAssertEqual(rect.top,              1)
		XCTAssertEqual(rect.topLeft,          CGPoint(x: 0, y: 1))
		XCTAssertEqual(rect.topCenter,        CGPoint(x: 1, y: 1))
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
		mutableRect.bottomCenter = CGPoint(x: 2, y: 5)
		XCTAssertEqual(mutableRect, CGRect(x: 1, y: 2, width: 2, height: 3))

		mutableRect = rect
		mutableRect.bottomRight = CGPoint(x: 3, y: 5)
		XCTAssertEqual(mutableRect, CGRect(x: 1, y: 2, width: 2, height: 3))

		mutableRect = rect
		mutableRect.centerLeft = CGPoint(x: 1, y: 3.5)
		XCTAssertEqual(mutableRect, CGRect(x: 1, y: 2, width: 2, height: 3))

		mutableRect = rect
		mutableRect.center = CGPoint(x: 2, y: 3.5)
		XCTAssertEqual(mutableRect, CGRect(x: 1, y: 2, width: 2, height: 3))

		mutableRect = rect
		mutableRect.centerRight = CGPoint(x: 3, y: 3.5)
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
		mutableRect.topCenter = CGPoint(x: 2, y: 2)
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
}

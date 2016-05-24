import XCTest

import JetPack


class Array_Tests: XCTestCase {

	func testToArray() {
		let a = EmptyNonEqualObject()
		let b = EmptyNonEqualObject()

		XCTAssertEqual([Int]().toArray(),   [])
		XCTAssertEqual([3, 1, 2].toArray(), [3, 1, 2])

		XCTAssertIdentical([b, a, b].toArray(), [b, a, b])
	}
}

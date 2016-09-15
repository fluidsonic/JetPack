import XCTest

import JetPack


class Any_Tests: XCTestCase {

	func testPatternMatching() {
		switch EmptyStruct.self {
		case EmptyStruct.self: break
		default:               XCTFail()
		}

		switch EmptyNonEqualObject.self {
		case EmptyNonEqualObject.self: break
		default:                       XCTFail()
		}
	}
}

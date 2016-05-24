import XCTest

import JetPack


class AnyClass_Tests: XCTestCase {

	func testPatternMatching() {
		switch EmptyNonEqualObject.self {
		case EmptyNonEqualObject.self: break
		default:                       XCTFail()
		}
	}
}

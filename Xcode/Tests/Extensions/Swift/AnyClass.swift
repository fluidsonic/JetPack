import XCTest

import JetPack


class AnyClass_Tests: XCTestCase {

	func testPatternMatching() {
		switch EmptyObject.self {
		case EmptyObject.self: break
		default:               XCTFail()
		}
	}
}

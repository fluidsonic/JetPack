import XCTest

import Foundation
import JetPack


class NSOrderedSet_Tests: XCTestCase {

	func testInit() {
		XCTAssertEqual(NSOrderedSet(elements: ["a", "b", "c"]).array as! [String], ["a", "b", "c"])
	}


	func testShortcutProperties() {
		XCTAssertTrue (([]   as NSOrderedSet).isEmpty)
		XCTAssertFalse(([""] as NSOrderedSet).isEmpty)
	}
}

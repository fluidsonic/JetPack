import XCTest

import Foundation
import JetPack


class NSOrderedSet_Tests: XCTestCase {

	func testInit() {
		let elements = ["a", "b", "c"]
		
		XCTAssertEqual(NSOrderedSet(elements: elements).array as! [String], elements)
	}


	func testShortcutProperties() {
		XCTAssertTrue (([]   as NSOrderedSet).isEmpty)
		XCTAssertFalse(([""] as NSOrderedSet).isEmpty)
	}
}

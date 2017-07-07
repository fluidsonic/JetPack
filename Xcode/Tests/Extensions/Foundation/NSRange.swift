import XCTest

import Foundation
import JetPack


class NSRange_Tests: XCTestCase {

	func testEndIndexInString() {
		let string = "abc"

		XCTAssertEqual(NSRange(location: 1,          length: 1).endIndexInString(string), string.index(string.startIndex, offsetBy: 2))
		XCTAssertEqual(NSRange(location: NSNotFound, length: 0).endIndexInString(string), nil)
	}


	func testInit() {
		let string = "abc"

		XCTAssertEqual(NSRange(forString: string), NSRange(location: 0, length: 3))
		XCTAssertEqual(NSRange(range: string.startIndex ..< string.endIndex, inString: string), NSRange(location: 0, length: 3))
		XCTAssertEqual(NSRange(range: nil, inString: string).location, NSNotFound)
	}


	func testStartIndexInString() {
		let string = "abc"

		XCTAssertEqual(NSRange(location: 1,          length: 1).startIndexInString(string), string.index(after: string.startIndex))
		XCTAssertEqual(NSRange(location: NSNotFound, length: 1).startIndexInString(string), nil)
	}


	func testRangeInString() {
		let string = "abc"

		XCTAssertEqual(NSRange(location: 0,          length: 3).rangeInString(string), string.startIndex ..< string.endIndex)
		XCTAssertEqual(NSRange(location: NSNotFound, length: 3).rangeInString(string), nil)
	}
}

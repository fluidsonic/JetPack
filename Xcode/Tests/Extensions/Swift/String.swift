import XCTest

import JetPack


class String_Tests: XCTestCase {

	func testTrimmedToLength() {
		XCTAssertEqual("test".trimmedToLength(0), "")
		XCTAssertEqual("test".trimmedToLength(1), "t")
		XCTAssertEqual("test".trimmedToLength(2), "te")
		XCTAssertEqual("test".trimmedToLength(3), "tes")
		XCTAssertEqual("test".trimmedToLength(4), "test")
		XCTAssertEqual("test".trimmedToLength(5), "test")
		XCTAssertEqual("test".trimmedToLength(0, truncationString: "…"), "")
		XCTAssertEqual("test".trimmedToLength(1, truncationString: "…"), "…")
		XCTAssertEqual("test".trimmedToLength(2, truncationString: "…"), "t…")
		XCTAssertEqual("test".trimmedToLength(3, truncationString: "…"), "te…")
		XCTAssertEqual("test".trimmedToLength(4, truncationString: "…"), "test")
		XCTAssertEqual("test".trimmedToLength(5, truncationString: "…"), "test")
		XCTAssertEqual("test".trimmedToLength(0, truncationString: "ABCDE"), "")
		XCTAssertEqual("test".trimmedToLength(1, truncationString: "ABCDE"), "A")
		XCTAssertEqual("test".trimmedToLength(2, truncationString: "ABCDE"), "AB")
		XCTAssertEqual("test".trimmedToLength(3, truncationString: "ABCDE"), "ABC")
		XCTAssertEqual("test".trimmedToLength(4, truncationString: "ABCDE"), "test")
		XCTAssertEqual("test".trimmedToLength(5, truncationString: "ABCDE"), "test")
	}


	func testWhitespaceTrimmed() {
		XCTAssertEqual(" \ntest\n ".whitespaceTrimmed, "test")
	}
}

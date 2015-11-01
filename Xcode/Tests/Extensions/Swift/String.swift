import XCTest

import Foundation
import JetPack


class String_Tests {

	func testFirstMatchForRegularExpression() {
		XCTAssertEqual("abcabc".firstMatchForRegularExpression(try! NSRegularExpression(pattern: "abcd", options: [])),   nil)
		XCTAssertEqual("abcabc".firstMatchForRegularExpression(try! NSRegularExpression(pattern: "(b)(c)", options: [])), ["bc", "b", "c"])
		XCTAssertEqual("abcabc".firstMatchForRegularExpression("abcd"),                                                   nil)
		XCTAssertEqual("abcabc".firstMatchForRegularExpression("(b)(c)"),                                                 ["bc", "b", "c"])
	}


	func testFirstSubstringMatchingRegularExpression() {
		XCTAssertEqual("ababab".firstSubstringMatchingRegularExpression("b."), "ba")
	}


	func testNonEmpty() {
		XCTAssertEqual("not empty".nonEmpty, "not empty")
		XCTAssertEqual("".nonEmpty,          nil)
	}


	func testStringByReplacingRegularExpression() {
		XCTAssertEqual("ababab".stringByReplacingRegularExpression(try! NSRegularExpression(pattern: "b", options: []), withTemplate: "$0c"), "abcabcabc")
		XCTAssertEqual("ababab".stringByReplacingRegularExpression("b",                                                 withTemplate: "$0c"), "abcabcabc")
	}


	func testTrimmed() {
		XCTAssertEqual(" \ntest\n ".trimmed, "test")
	}


	func testTrimmedToLength() {
		XCTAssertEqual("test".trimmedToLength(0), "")
		XCTAssertEqual("test".trimmedToLength(1), "t")
		XCTAssertEqual("test".trimmedToLength(2), "te")
		XCTAssertEqual("test".trimmedToLength(3), "tes")
		XCTAssertEqual("test".trimmedToLength(4), "test")
		XCTAssertEqual("test".trimmedToLength(5), "test")
	}


	func testUrlEncoding() {
		let url = "https://github.com/fluidsonic/JetPack/blob/master/Xcode/Tests/Extensions/Foundation/NSCharacterSet.swift?a=b&c=d+e#L1"
		XCTAssertEqual(url.urlEncodedPath,
			"https://github.com/fluidsonic/JetPack/blob/master/Xcode/Tests/Extensions/Foundation/NSCharacterSet.swift?a=b&c=d+e#L1")
		XCTAssertEqual(url.urlEncodedPathComponent,
			"https://github.com/fluidsonic/JetPack/blob/master/Xcode/Tests/Extensions/Foundation/NSCharacterSet.swift?a=b&c=d+e#L1")
		XCTAssertEqual(url.urlEncodedQuery,
			"https://github.com/fluidsonic/JetPack/blob/master/Xcode/Tests/Extensions/Foundation/NSCharacterSet.swift?a=b&c=d+e#L1")
		XCTAssertEqual(url.urlEncodedQueryParameter,
			"https://github.com/fluidsonic/JetPack/blob/master/Xcode/Tests/Extensions/Foundation/NSCharacterSet.swift?a=b&c=d+e#L1")
	}
}

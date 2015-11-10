import XCTest

import Foundation
import JetPack


class String_Tests: XCTestCase {

	func testFirstMatchForRegularExpression() {
		XCTAssertEqual("abcabc".firstMatchForRegularExpression(try! NSRegularExpression(pattern: "abcd", options: [])),   nil)
		XCTAssertEqual("abcabc".firstMatchForRegularExpression(try! NSRegularExpression(pattern: "(b)(c)", options: [])), ["bc", "b", "c"])
		XCTAssertEqual("abcabc".firstMatchForRegularExpression("abcd"),                                                   nil)
		XCTAssertEqual("abcabc".firstMatchForRegularExpression("(b)(c)"),                                                 ["bc", "b", "c"])
	}


	func testFirstSubstringMatchingRegularExpression() {
		XCTAssertEqual("ababab".firstSubstringMatchingRegularExpression("b."), "ba")
		XCTAssertEqual("ababab".firstSubstringMatchingRegularExpression("c."), nil)
	}


	func testNonEmpty() {
		XCTAssertEqual("not empty".nonEmpty, "not empty")
		XCTAssertEqual("".nonEmpty,          nil)
	}


	func testStringByReplacingRegularExpression() {
		XCTAssertEqual("ababab".stringByReplacingRegularExpression(try! NSRegularExpression(pattern: "b", options: []), withTemplate: "$0c"), "abcabcabc")
		XCTAssertEqual("ababab".stringByReplacingRegularExpression("b",                                                 withTemplate: "$0c"), "abcabcabc")
	}


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


	func testUrlEncoding() {
		let url = "https://github.com/fluidsonic/JetPack/blob/master/Xcode/Tests/Extensions/Foundation/NSCharacterSet.swift?a=b&c=d+e#L1"
		XCTAssertEqual(url.urlEncodedHost,
			"https%3A%2F%2Fgithub.com%2Ffluidsonic%2FJetPack%2Fblob%2Fmaster%2FXcode%2FTests%2FExtensions%2FFoundation%2FNSCharacterSet.swift%3Fa=b&c=d+e%23L1")
		XCTAssertEqual(url.urlEncodedPath,
			"https%3A//github.com/fluidsonic/JetPack/blob/master/Xcode/Tests/Extensions/Foundation/NSCharacterSet.swift%3Fa=b&c=d+e%23L1")
		XCTAssertEqual(url.urlEncodedPathComponent,
			"https:%2F%2Fgithub.com%2Ffluidsonic%2FJetPack%2Fblob%2Fmaster%2FXcode%2FTests%2FExtensions%2FFoundation%2FNSCharacterSet.swift%3Fa=b&c=d+e%23L1")
		XCTAssertEqual(url.urlEncodedQuery,
			"https://github.com/fluidsonic/JetPack/blob/master/Xcode/Tests/Extensions/Foundation/NSCharacterSet.swift?a=b&c=d+e%23L1")
		XCTAssertEqual(url.urlEncodedQueryParameter,
			"https://github.com/fluidsonic/JetPack/blob/master/Xcode/Tests/Extensions/Foundation/NSCharacterSet.swift?a%3Db%26c%3Dd%2Be%23L1")

		let invalidString = String(bytes: [0xD8, 0x00], encoding: NSUTF16BigEndianStringEncoding)!
		XCTAssertEqual(invalidString.urlEncodedHost,           "<url encoding failed>")
		XCTAssertEqual(invalidString.urlEncodedPath,           "<url encoding failed>")
		XCTAssertEqual(invalidString.urlEncodedPathComponent,  "<url encoding failed>")
		XCTAssertEqual(invalidString.urlEncodedQuery,          "<url encoding failed>")
		XCTAssertEqual(invalidString.urlEncodedQueryParameter, "<url encoding failed>")
	}
	

	func testWhitespaceTrimmed() {
		XCTAssertEqual(" \ntest\n ".whitespaceTrimmed, "test")
	}
}

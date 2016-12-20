import XCTest

import Foundation
import JetPack


class NSMutableAttributedString_Tests: XCTestCase {

	fileprivate func attributedString(_ string: String, attributes: [(range: CountableClosedRange<Int>, name: String, value: Any)]) -> NSMutableAttributedString {
		let attributedString = NSMutableAttributedString(string: string)
		for attribute in attributes {
			let range = NSRange(location: attribute.range.lowerBound, length: attribute.range.upperBound - attribute.range.lowerBound + 1)
			attributedString.addAttribute(attribute.name, value: attribute.value, range: range)
		}

		return attributedString
	}


	func testAppendString() {
		do {
			let expectedString = attributedString("rednothing", attributes: [(range: 0 ... 2, name: NSForegroundColorAttributeName, value: UIColor.red)])

			let string = attributedString("red", attributes: [(range: 0 ... 2, name: NSForegroundColorAttributeName, value: UIColor.red)])
			string.appendString("nothing")
			XCTAssertEqual(string, expectedString)
		}

		do {
			let expectedString = attributedString("redred", attributes: [(range: 0 ... 5, name: NSForegroundColorAttributeName, value: UIColor.red)])

			let string = attributedString("red", attributes: [(range: 0 ... 2, name: NSForegroundColorAttributeName, value: UIColor.red)])
			string.appendString("red", maintainingPrecedingAttributes: true)
			XCTAssertEqual(string, expectedString)
		}

		do {
			let expectedString = attributedString("redcustom", attributes: [
				(range: 0 ... 2, name: NSForegroundColorAttributeName, value: UIColor.red),
				(range: 3 ... 8, name: "a", value: "a"),
				(range: 3 ... 8, name: "b", value: "b")
				])

			let string = attributedString("red", attributes: [(range: 0 ... 2, name: NSForegroundColorAttributeName, value: UIColor.red)])
			string.appendString("custom", additionalAttributes: [
				"a": "a",
				"b": "b"
			])
			XCTAssertEqual(string, expectedString)
		}

		do {
			let expectedString = attributedString("redcustom", attributes: [
				(range: 0 ... 8, name: NSForegroundColorAttributeName, value: UIColor.red),
				(range: 3 ... 8, name: "a", value: "a"),
				(range: 3 ... 8, name: "b", value: "b")
				])

			let string = attributedString("red", attributes: [(range: 0 ... 2, name: NSForegroundColorAttributeName, value: UIColor.red)])
			string.appendString("custom", maintainingPrecedingAttributes: true, additionalAttributes: [
				"a": "a",
				"b": "b"
			])
			XCTAssertEqual(string, expectedString)
		}
	}
}

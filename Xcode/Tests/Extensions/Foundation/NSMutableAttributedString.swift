import XCTest

import Foundation
import JetPack


class NSMutableAttributedString_Tests: XCTestCase {

	private func attributedString(string: String, attributes: [(range: Range<Int>, name: String, value: AnyObject)]) -> NSMutableAttributedString {
		let attributedString = NSMutableAttributedString(string: string)
		for attribute in attributes {
			let range = NSRange(location: attribute.range.startIndex, length: attribute.range.endIndex - attribute.range.startIndex)
			attributedString.addAttribute(attribute.name, value: attribute.value, range: range)
		}

		return attributedString
	}


	func testAppendString() {
		do {
			let expectedString = attributedString("redred", attributes: [(range: 0 ... 5, name: NSForegroundColorAttributeName, value: UIColor.redColor())])

			let string = attributedString("red", attributes: [(range: 0 ... 2, name: NSForegroundColorAttributeName, value: UIColor.redColor())])
			string.appendString("red")
			XCTAssertEqual(string, expectedString)
		}

		do {
			let expectedString = attributedString("redblue", attributes: [
				(range: 0 ... 2, name: NSForegroundColorAttributeName, value: UIColor.redColor()),
				(range: 3 ... 6, name: NSForegroundColorAttributeName, value: UIColor.blueColor())
			])

			let string = attributedString("red", attributes: [(range: 0 ... 2, name: NSForegroundColorAttributeName, value: UIColor.redColor())])
			string.appendString("blue", attribute: NSForegroundColorAttributeName, value: UIColor.blueColor())
			XCTAssertEqual(string, expectedString)
		}

		do {
			let expectedString = attributedString("redcustom", attributes: [
				(range: 0 ... 8, name: NSForegroundColorAttributeName, value: UIColor.redColor()),
				(range: 3 ... 8, name: "a", value: "a"),
				(range: 3 ... 8, name: "b", value: "b")
			])

			let string = attributedString("red", attributes: [(range: 0 ... 2, name: NSForegroundColorAttributeName, value: UIColor.redColor())])
			string.appendString("custom", attributes: [
				"a": "a",
				"b": "b"
			])
			XCTAssertEqual(string, expectedString)
		}
	}
}

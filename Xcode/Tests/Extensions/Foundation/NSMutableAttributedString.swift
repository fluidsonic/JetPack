import XCTest

import Foundation
import JetPack


class NSMutableAttributedString_Tests: XCTestCase {

	private let testKey1 = NSAttributedString.Key("a")
	private let testKey2 = NSAttributedString.Key("b")


	fileprivate func attributedString(_ string: String, attributes: [(range: CountableClosedRange<Int>, name: NSAttributedString.Key, value: Any)]) -> NSMutableAttributedString {
		let attributedString = NSMutableAttributedString(string: string)
		for attribute in attributes {
			let range = NSRange(location: attribute.range.lowerBound, length: attribute.range.upperBound - attribute.range.lowerBound + 1)
			attributedString.addAttribute(attribute.name, value: attribute.value, range: range)
		}

		return attributedString
	}


	func testAppendString() {
		do {
			let expectedString = attributedString("rednothing", attributes: [(range: 0 ... 2, name: .foregroundColor, value: UIColor.red)])

			let string = attributedString("red", attributes: [(range: 0 ... 2, name: .foregroundColor, value: UIColor.red)])
			string.appendString("nothing")
			XCTAssertEqual(string, expectedString)
		}

		do {
			let expectedString = attributedString("redred", attributes: [(range: 0 ... 5, name: .foregroundColor, value: UIColor.red)])

			let string = attributedString("red", attributes: [(range: 0 ... 2, name: .foregroundColor, value: UIColor.red)])
			string.appendString("red", maintainingPrecedingAttributes: true)
			XCTAssertEqual(string, expectedString)
		}

		do {
			let expectedString = attributedString("redcustom", attributes: [
				(range: 0 ... 2, name: .foregroundColor, value: UIColor.red),
				(range: 3 ... 8, name: testKey1, value: testKey1.rawValue),
				(range: 3 ... 8, name: testKey2, value: testKey2.rawValue)
			])

			let string = attributedString("red", attributes: [(range: 0 ... 2, name: .foregroundColor, value: UIColor.red)])
			string.appendString("custom", additionalAttributes: [
				testKey1: testKey1.rawValue,
				testKey2: testKey2.rawValue
			])
			XCTAssertEqual(string, expectedString)
		}

		do {
			let expectedString = attributedString("redcustom", attributes: [
				(range: 0 ... 8, name: .foregroundColor, value: UIColor.red),
				(range: 3 ... 8, name: testKey1, value: testKey1.rawValue),
				(range: 3 ... 8, name: testKey2, value: testKey2.rawValue)
				])

			let string = attributedString("red", attributes: [(range: 0 ... 2, name: .foregroundColor, value: UIColor.red)])
			string.appendString("custom", maintainingPrecedingAttributes: true, additionalAttributes: [
				testKey1: testKey1.rawValue,
				testKey2: testKey2.rawValue
			])
			XCTAssertEqual(string, expectedString)
		}
	}
}

import XCTest

import Foundation
import JetPack


class Locale_Tests: XCTestCase {

	func testPluralCategories() {
		let data: [String : [NSNumber : Locale.PluralCategory]] = [
			"de_DE": [
				0: .other,
				1: .one,
				2: .other
			],
			"en_US": [
				0: .other,
				1: .one,
				2: .other
			],
			"ru": [
				 0: .many,
				 1: .one,
				 2: .few,
				 3: .few,
				 4: .few,
				 5: .many,
				 6: .many,
				 7: .many,
				 8: .many,
				 9: .many,
				10: .many,
				11: .many,
				20: .many,
				21: .one,
				22: .few
			],
			"unknown": [
				0: .other,
				1: .other,
				2: .other
			]
		]

		for (localeIdentifier, values) in data {
			let locale = Locale(identifier: localeIdentifier)
			for (number, expectedCategory) in values {
				let category = locale.pluralCategoryForNumber(number)
				if category != expectedCategory {
					XCTFail("Expected plural category for number '\(number)' to be '\(expectedCategory)' for locale '\(localeIdentifier)' but is '\(category)'.")
				}
			}
		}
	}


	func testUses24HourFormat() {
		XCTAssertEqual(Locale(identifier: "en_US").uses24HourFormat, false)
		XCTAssertEqual(Locale(identifier: "de_DE").uses24HourFormat, true)
	}


	func testUsesMetricSystem() {
		XCTAssertEqual(Locale(identifier: "en_US").usesMetricSystem9, false)
		XCTAssertEqual(Locale(identifier: "de_DE").usesMetricSystem9, true)
	}
}

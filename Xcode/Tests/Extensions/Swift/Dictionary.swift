import XCTest

import JetPack


class Dictionary_Tests: XCTestCase {

	fileprivate let error = NSError(domain: "", code: 0, userInfo: nil)


	func testFilterAsDictionary() {
		let dictionary = [0: 1, 1: 0, 2: 2]
		XCTAssertEqual(dictionary.filterAsDictionary { key, value in key == 0 || value == 0 }, [0: 1, 1: 0])
		XCTAssertEqual(dictionary.filterAsDictionary { $0 == 0 || $1 == 0 },                   [0: 1, 1: 0])

		do {
			let _ = try dictionary.filterAsDictionary { _, _ in throw error }
			XCTFail()
		}
		catch let error as NSError {
			XCTAssertEqual(error, self.error)
		}
	}


	func testFilterInPlace() {
		let dictionary = [0: 1, 1: 0, 2: 2]

		var mutableDictionary = dictionary
		mutableDictionary.filterInPlace { key, value in key == 0 || value == 0 }
		XCTAssertEqual(mutableDictionary, [0: 1, 1: 0])

		mutableDictionary = dictionary
		mutableDictionary.filterInPlace { $0 == 0 || $1 == 0 }
		XCTAssertEqual(mutableDictionary, [0: 1, 1: 0])

		do {
			mutableDictionary = dictionary
			try mutableDictionary.filterInPlace { _, _ in throw error }
			XCTFail()
		}
		catch let error as NSError {
			XCTAssertEqual(error, self.error)
		}
	}


	func testMapAsDictionary() {
		let dictionary = [0: 1, 1: 0, 2: 2]
		XCTAssertEqual(dictionary.mapAsDictionary { key, value in (key / 2, value * 2) }, [0: 0, 1: 4])
		XCTAssertEqual(dictionary.mapAsDictionary { ($0 / 2, $1 * 2) },                   [0: 0, 1: 4])

		do {
			let _ = try dictionary.mapAsDictionary { _, _ -> (Int, Int) in throw error }
			XCTFail()
		}
		catch let error as NSError {
			XCTAssertEqual(error, self.error)
		}
	}


	func testMapInPlace() {
		var dictionary = [0: 0, 1: 0, 2: 2]
		dictionary.mapInPlace { $0 + 1 }
		XCTAssertEqual(dictionary, [0: 1, 1: 1, 2: 3])

		do {
			dictionary = [0: 0]
			try dictionary.mapInPlace { _ in throw error }
			XCTFail()
		}
		catch let error as NSError {
			XCTAssertEqual(error, self.error)
		}
	}


	func testUpdateValues() {
		var dictionary = [0: 0, 1: 1, 2: 2]
		dictionary.updateValues([1: 2, 2: 3])
		XCTAssertEqual(dictionary, [0: 0, 1: 2, 2: 3])
	}
}

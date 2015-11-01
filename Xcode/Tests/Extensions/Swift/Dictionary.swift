import XCTest

import JetPack


class Dictionary_Tests: XCTestCase {

	private let error = NSError(domain: "", code: 0, userInfo: nil)


	func testMapAsDictionary() {
		XCTAssertEqual([0: 0, 1: 0, 2: 2].mapAsDictionary { ($0 / 2, $1 * 2) }, [0: 0, 1: 4])

		do {
			let dictionary = [0: 0]
			let _ = try dictionary.mapAsDictionary { _ -> (Int, Int) in throw error }
			XCTFail()
		}
		catch let error as NSError {
			XCTAssertEqual(error, self.error)
		}
	}


	func testMapInPlace() {
		do {
			var dictionary = ["a": 1, "b": 2]
			dictionary.mapInPlace { $0 + 1 }
			XCTAssertEqual(dictionary, ["a": 2, "b": 3])
		}

		do {
			var dictionary = [0: 0]
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

import XCTest

import JetPack


class CollectionType_Tests: XCTestCase {

	private let error = NSError(domain: "", code: 0, userInfo: nil)


	func testIndexOfIdentical() {
		let objects = [EmptyNonEqualObject(), EmptyNonEqualObject(), EmptyNonEqualObject()]
		XCTAssertEqual(objects.indexOfIdentical(EmptyNonEqualObject()), nil)
		XCTAssertEqual(objects.indexOfIdentical(objects[1]),            1)
	}


	func testLastIndexOf() {
		let elements = [1, 1, 2]
		XCTAssertEqual(elements.lastIndexOf(1),          1)
		XCTAssertEqual(elements.lastIndexOf(3),          nil)
		XCTAssertEqual(elements.lastIndexOf { $0 == 1 }, 1)

		do {
			let _ = try [true].lastIndexOf { _ in throw error }
			XCTFail()
		}
		catch let error as NSError {
			XCTAssertEqual(error, self.error)
		}
	}


	func testRandomElement() {
		XCTAssertEqual([String]().randomElement, nil)
		XCTAssertEqual([true].randomElement, true)
	}
}

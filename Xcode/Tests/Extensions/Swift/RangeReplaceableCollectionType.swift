import XCTest

import JetPack


class RangeReplaceableCollectionType_Tests: XCTestCase {

	fileprivate let error = NSError(domain: "", code: 0, userInfo: nil)


	func testRemoveFirstEqual() {
		var objects = [1, 1, 2]
		XCTAssertEqual(objects.removeFirstEqual(1), (0, 1))
		XCTAssertEqual(objects, [1, 2])

		objects = [1, 1, 2]
		XCTAssertEqual(objects.removeFirstEqual(3), nil)
		XCTAssertEqual(objects, [1, 1, 2])
	}


	func testRemoveFirstIdentical() {
		let objects = [EmptyNonEqualObject(), EmptyNonEqualObject(), EmptyNonEqualObject()]

		var mutableObjects = objects
		XCTAssertEqual(mutableObjects.removeFirstIdentical(objects[1]), 1)
		XCTAssertIdentical(mutableObjects, [objects[0], objects[2]])

		mutableObjects = objects
		XCTAssertEqual(mutableObjects.removeFirstIdentical(EmptyNonEqualObject()), nil)
		XCTAssertIdentical(mutableObjects, objects)
	}


	func testRemoveFirstMatching() {
		do {
			var objects = [1, 1, 2]
			XCTAssertEqual(objects.removeFirstMatching { $0 == 1 }, (0, 1))
			XCTAssertEqual(objects, [1, 2])

			objects = [1, 1, 2]
			XCTAssertEqual(objects.removeFirstMatching { $0 == 3 }, nil)
			XCTAssertEqual(objects, [1, 1, 2])
		}

		do {
			var array = [true]
			try array.removeFirstMatching { _ in throw error }
			XCTFail()
		}
		catch let error as NSError {
			XCTAssertEqual(error, self.error)
		}
	}
}

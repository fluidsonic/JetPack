import XCTest

import JetPack


class RangeReplaceableCollectionType_Tests: XCTestCase {

	private let error = NSError(domain: "", code: 0, userInfo: nil)


	func testRemoveFirst() {
		do {
			var objects = [1, 1, 2]
			XCTAssertEqual(objects.removeFirst(1), (0, 1))
			XCTAssertEqual(objects, [1, 2])

			objects = [1, 1, 2]
			XCTAssertEqual(objects.removeFirst(3), nil)
			XCTAssertEqual(objects, [1, 1, 2])

			objects = [1, 1, 2]
			XCTAssertEqual(objects.removeFirst { $0 == 1 }, (0, 1))
			XCTAssertEqual(objects, [1, 2])

			objects = [1, 1, 2]
			XCTAssertEqual(objects.removeFirst { $0 == 3 }, nil)
			XCTAssertEqual(objects, [1, 1, 2])
		}

		do {
			var array = [true]
			try array.removeFirst { _ in throw error }
			XCTFail()
		}
		catch let error as NSError {
			XCTAssertEqual(error, self.error)
		}
	}


	func testRemoveFirstIdentical() {
		let objects = [EmptyObject(), EmptyObject(), EmptyObject()]

		var mutableObjects = objects
		XCTAssertEqual(mutableObjects.removeFirstIdentical(objects[1]), 1)
		XCTAssertIdentical(mutableObjects, [objects[0], objects[2]])

		mutableObjects = objects
		XCTAssertEqual(mutableObjects.removeFirstIdentical(EmptyObject()), nil)
		XCTAssertIdentical(mutableObjects, objects)
	}
}

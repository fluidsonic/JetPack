import XCTest

import JetPack


class SequenceType_Tests: XCTestCase {

	fileprivate let error = NSError(domain: "", code: 0, userInfo: nil)


	func testAssociated() {
		XCTAssertEqual(AnySequence<Int>([]).associated() { ($0, $0) },      [:])
		XCTAssertEqual(AnySequence([1, 2, 3]).associated(elementSelector: { ($0, $0 * 2) }), [1: 2, 2: 4, 3: 6])

		XCTAssertEqual(AnySequence([(1, 1), (2, 2), (1, 3)]).associated(elementSelector: { $0 }), [2: 2, 1: 3])
	}


	func testContainsIdentical() {
		let objects = [EmptyNonEqualObject(), EmptyNonEqualObject()]
		XCTAssertFalse(objects.containsIdentical(EmptyNonEqualObject()))
		XCTAssertTrue(objects.containsIdentical(objects[1]))
	}


	func testCountMatching() {
		XCTAssertEqual([1, 1, 2].countMatching { $0 == 1 }, 2)

		do {
			let _ = try [true].countMatching { _ in throw error }
			XCTFail()
		}
		catch let error as NSError {
			XCTAssertEqual(error, self.error)
		}
	}


	func testFilterNonNil() {
		XCTAssertEqual([Int?]().filterNonNil(), [])

		let array: [Int?] = [nil, 1, nil, nil, 2, nil]
		XCTAssertEqual(array.filterNonNil(), [1, 2])
	}


	func testFirstMatching() {
		XCTAssertEqual([1, 1, 2].firstMatching { $0 == 1 }, 1)
		XCTAssertEqual([1, 1, 2].firstMatching { $0 == 3 }, nil)

		do {
			let _ = try [true].firstMatching { _ in throw error }
			XCTFail()
		}
		catch let error as NSError {
			XCTAssertEqual(error, self.error)
		}
	}


	func testSeparate() {
		let (left, right) = [1, 2, 3, 4].separate { $0 % 2 != 0 }
		XCTAssertEqual(left,  [1, 3])
		XCTAssertEqual(right, [2, 4])

		do {
			let _ = try [true].separate { _ in throw error }
			XCTFail()
		}
		catch let error as NSError {
			XCTAssertEqual(error, self.error)
		}
	}


	func testToArray() {
		let a = EmptyNonEqualObject()
		let b = EmptyNonEqualObject()

		XCTAssertEqual(AnySequence<Int>([]).toArray(),   [])
		XCTAssertEqual(AnySequence([3, 1, 2]).toArray(), [3, 1, 2])

		XCTAssertIdentical(AnySequence([b, a, b]).toArray(), [b, a, b])
	}


	func testToSet() {
		let a = EmptyEqualObject()
		let b = EmptyEqualObject()

		XCTAssertEqual(AnySequence<Int>([]).toSet(),   Set([]))
		XCTAssertEqual(AnySequence([3, 1, 2]).toSet(), Set([3, 1, 2]))
		XCTAssertEqual(AnySequence([b, a]).toSet(),    Set([a]))
	}
}

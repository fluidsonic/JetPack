import XCTest

import JetPack


class SequenceType_Tests: XCTestCase {

	private let error = NSError(domain: "", code: 0, userInfo: nil)


	func testContainsIdentical() {
		let objects = [EmptyObject(), EmptyObject()]
		XCTAssertFalse(objects.containsIdentical(EmptyObject()))
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
}

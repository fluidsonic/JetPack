import XCTest

import JetPack


class Set_Tests: XCTestCase {

	private let error = NSError(domain: "", code: 0, userInfo: nil)


	func testFilterAsSet() {
		XCTAssertEqual(Set([true, false]).filterAsSet { $0 }, [true])

		do {
			let _ = try Set([true]).filterAsSet { _ in throw error }
			XCTFail()
		}
		catch let error as NSError {
			XCTAssertEqual(error, self.error)
		}
	}


	func testFilterInPlace() {
		do {
			var set: Set = [true, false]
			set.filterInPlace { $0 }
			XCTAssertEqual(set, [true])
		}

		do {
			var set: Set = [true]
			try set.filterInPlace { _ in throw error }
			XCTFail()
		}
		catch let error as NSError {
			XCTAssertEqual(error, self.error)
		}
	}


	func testInit() {
		XCTAssertEqual(Set(element: 1), [1] as Set)
	}


	func testToSet() {
		let a = EmptyEqualObject()
		let b = EmptyEqualObject()

		XCTAssertEqual(Set<Int>().toSet(),     Set([]))
		XCTAssertEqual(Set([3, 1, 2]).toSet(), Set([3, 1, 2]))

		XCTAssertIdentical(Set([b, a]).toSet(), Set([a]))
	}
}

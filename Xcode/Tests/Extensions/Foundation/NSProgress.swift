import XCTest

import Foundation
import JetPack


class NSProgress_Tests: XCTestCase {

	func testFractionCompletedHandler() {
		var _fractionCompleted: Double?

		let progress = Progress(totalUnitCount: 100)
		progress.fractionCompletedHandler = { fractionCompleted in
			guard _fractionCompleted == nil else {
				XCTFail("fractionCompletedHandler called too often")
				return
			}

			_fractionCompleted = fractionCompleted
		}

		XCTAssertNotNil(progress.fractionCompletedHandler)

		progress.completedUnitCount = 1
		progress.fractionCompletedHandler = nil

		XCTAssertEqual(_fractionCompleted, progress.fractionCompleted)
		XCTAssertNil(progress.fractionCompletedHandler)
	}


	func testFractionCompletedHandlerDeinit() {
		var progressWithHandler: Progress? = Progress()
		progressWithHandler?.fractionCompletedHandler = { _ in }
		progressWithHandler = nil

		_ = Progress()
	}
}

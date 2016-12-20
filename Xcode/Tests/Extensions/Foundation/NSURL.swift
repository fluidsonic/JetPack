import XCTest

import Foundation
import JetPack


class NSURL_Tests: XCTestCase {

	func testInit() {
		XCTAssertEqual(URL(forPhoneCallWithNumber: ""),                URL(string: "tel:"))
		XCTAssertEqual(URL(forPhoneCallWithNumber: "123-456-789"),     URL(string: "tel:123-456-789"))
		XCTAssertEqual(URL(forPhoneCallWithNumber: "123/456#789?012"), URL(string: "tel:123%2F456%23789%3F012"))

		XCTAssertEqual(URL(forPhoneCallPromptWithNumber: ""),                URL(string: "telprompt:"))
		XCTAssertEqual(URL(forPhoneCallPromptWithNumber: "123-456-789"),     URL(string: "telprompt:123-456-789"))
		XCTAssertEqual(URL(forPhoneCallPromptWithNumber: "123/456#789?012"), URL(string: "telprompt:123%2F456%23789%3F012"))
	}
}

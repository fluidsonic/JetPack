import XCTest

import Foundation
import JetPack


class NSURL_Tests: XCTestCase {

	func testInit() {
		XCTAssertEqual(NSURL(forPhoneCallWithNumber: ""),                NSURL(string: "tel:"))
		XCTAssertEqual(NSURL(forPhoneCallWithNumber: "123-456-789"),     NSURL(string: "tel:123-456-789"))
		XCTAssertEqual(NSURL(forPhoneCallWithNumber: "123:456#789?012"), NSURL(string: "tel:123%3A456%23789%3F012"))

		XCTAssertEqual(NSURL(forPhoneCallPromptWithNumber: ""),                NSURL(string: "telprompt:"))
		XCTAssertEqual(NSURL(forPhoneCallPromptWithNumber: "123-456-789"),     NSURL(string: "telprompt:123-456-789"))
		XCTAssertEqual(NSURL(forPhoneCallPromptWithNumber: "123:456#789?012"), NSURL(string: "telprompt:123%3A456%23789%3F012"))
	}
}

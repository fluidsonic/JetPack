import XCTest

import Foundation
import JetPack


class NSCharacterSet_Tests: XCTestCase {

	func testUrlPathComponentSet() {
		XCTAssertEqual(
			"https://github.com/fluidsonic/JetPack/blob/master/Xcode/Tests/Extensions/Foundation/NSCharacterSet.swift?a=b&c=d+e#L1"
				.addingPercentEncoding(withAllowedCharacters: .URLPathComponentAllowedCharacterSet()),
			"https:%2F%2Fgithub.com%2Ffluidsonic%2FJetPack%2Fblob%2Fmaster%2FXcode%2FTests%2FExtensions%2FFoundation%2FNSCharacterSet.swift%3Fa=b&c=d+e%23L1"
		)
	}


	func testUrlQueryParameterSet() {
		XCTAssertEqual(
			"https://github.com/fluidsonic/JetPack/blob/master/Xcode/Tests/Extensions/Foundation/NSCharacterSet.swift?a=b&c=d+e#L1"
				.addingPercentEncoding(withAllowedCharacters: .URLQueryParameterAllowedCharacterSet()),
			"https://github.com/fluidsonic/JetPack/blob/master/Xcode/Tests/Extensions/Foundation/NSCharacterSet.swift?a%3Db%26c%3Dd%2Be%23L1"
		)
	}
}

import Foundation

// https://developer.apple.com/library/ios/featuredarticles/iPhoneURLScheme_Reference/Introduction/Introduction.html


public extension NSURL {

	public convenience init(forPhoneCallWithNumber phoneNumber: String) {
		self.init(string: "tel:\(phoneNumber.urlEncodedPath)")!
	}


	public convenience init(forPhoneCallPromptWithNumber phoneNumber: String) {
		self.init(string: "telprompt:\(phoneNumber.urlEncodedPath)")!
	}
}

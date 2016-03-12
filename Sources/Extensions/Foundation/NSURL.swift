import Foundation

// https://developer.apple.com/library/ios/featuredarticles/iPhoneURLScheme_Reference/Introduction/Introduction.html


public extension NSURL {

	@nonobjc
	public convenience init(forPhoneCallWithNumber phoneNumber: String) {
		self.init(string: "tel:\(phoneNumber.urlEncodedPath)")!
	}


	@nonobjc
	public convenience init(forPhoneCallPromptWithNumber phoneNumber: String) {
		self.init(string: "telprompt:\(phoneNumber.urlEncodedPath)")!
	}


	@nonobjc
	public func URLByAppendingQueryItems(queryItems: [NSURLQueryItem]) -> NSURL? {
		guard !queryItems.isEmpty else {
			return self
		}

		guard let urlComponents = NSURLComponents(URL: self, resolvingAgainstBaseURL: false) else {
			return nil
		}

		urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems

		return urlComponents.URL
	}
}

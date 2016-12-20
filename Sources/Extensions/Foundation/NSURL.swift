import Foundation

// https://developer.apple.com/library/ios/featuredarticles/iPhoneURLScheme_Reference/Introduction/Introduction.html


public extension URL {

	@nonobjc
	public init(forPhoneCallWithNumber phoneNumber: String) {
		self.init(string: "tel:\(phoneNumber.urlEncodedHost)")!
	}


	@nonobjc
	public init(forPhoneCallPromptWithNumber phoneNumber: String) {
		self.init(string: "telprompt:\(phoneNumber.urlEncodedHost)")!
	}


	
	public func URLByAppendingQueryItems(_ queryItems: [URLQueryItem]) -> URL? {
		guard !queryItems.isEmpty else {
			return self
		}

		guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
			return nil
		}

		urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems

		return urlComponents.url
	}
}

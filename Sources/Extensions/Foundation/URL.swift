import Foundation

// https://developer.apple.com/library/ios/featuredarticles/iPhoneURLScheme_Reference/Introduction/Introduction.html


extension URL {

	public init(forPhoneCallWithNumber phoneNumber: String) {
		self.init(string: "tel:\(phoneNumber.urlEncodedHost)")!
	}


	public init(forPhoneCallPromptWithNumber phoneNumber: String) {
		self.init(string: "telprompt:\(phoneNumber.urlEncodedHost)")!
	}


	public mutating func append(_ queryItems: [URLQueryItem]) {
		self = appending(queryItems)
	}


	public func appending(_ queryItems: [URLQueryItem]) -> URL {
		guard !queryItems.isEmpty else {
			return self
		}

		guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
			return self
		}

		urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems

		return urlComponents.url ?? self
	}
}

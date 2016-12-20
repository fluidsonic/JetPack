import Foundation


public extension String {

	
	public func firstMatchForRegularExpression(_ regularExpression: NSRegularExpression) -> [String?]? {
		guard let match = regularExpression.firstMatch(in: self, options: [], range: NSMakeRange(0, utf16.count)) else {
			return nil
		}

		return (0 ..< match.numberOfRanges).map { match.rangeAt($0).rangeInString(self).map { self[$0] } }
	}


	
	public func firstMatchForRegularExpression(_ regularExpressionPattern: String) -> [String?]? {
		do {
			let regularExpression = try NSRegularExpression(pattern: regularExpressionPattern, options: [])
			return firstMatchForRegularExpression(regularExpression)
		}
		catch let error {
			fatalError("Invalid regular expression pattern: \(error)")
		}
	}


	
	public func firstSubstringMatchingRegularExpression(_ regularExpressionPattern: String) -> String? {
		if let range = range(of: regularExpressionPattern, options: .regularExpression) {
			return self[range]
		}

		return nil
	}


	
	public func stringByReplacingRegularExpression(_ regularExpression: NSRegularExpression, withTemplate template: String) -> String {
		return regularExpression.stringByReplacingMatches(in: self, options: [], range: NSMakeRange(0, utf16.count), withTemplate: template)
	}


	
	public func stringByReplacingRegularExpression(_ regularExpressionPattern: String, withTemplate template: String) -> String {
		do {
			let regularExpression = try NSRegularExpression(pattern: regularExpressionPattern, options: NSRegularExpression.Options.dotMatchesLineSeparators)
			return stringByReplacingRegularExpression(regularExpression, withTemplate: template)
		}
		catch let error {
			fatalError("Invalid regular expression pattern: \(error)")
		}
	}


	public var urlEncodedHost: String {
		return addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed) ?? "<url encoding failed>"
	}


	public var urlEncodedPath: String {
		return addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed) ?? "<url encoding failed>"
	}


	public var urlEncodedPathComponent: String {
		return addingPercentEncoding(withAllowedCharacters: CharacterSet.URLPathComponentAllowedCharacterSet()) ?? "<url encoding failed>"
	}


	public var urlEncodedQuery: String {
		return addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "<url encoding failed>"
	}


	public var urlEncodedQueryParameter: String {
		return addingPercentEncoding(withAllowedCharacters: CharacterSet.URLQueryParameterAllowedCharacterSet()) ?? "<url encoding failed>"
	}
}

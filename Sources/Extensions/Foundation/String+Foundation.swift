import Foundation


public extension String {

	@warn_unused_result
	public func firstMatchForRegularExpression(regularExpression: NSRegularExpression) -> [String?]? {
		guard let match = regularExpression.firstMatchInString(self, options: [], range: NSMakeRange(0, utf16.count)) else {
			return nil
		}

		return (0 ..< match.numberOfRanges).map { match.rangeAtIndex($0).rangeInString(self).map { self[$0] } }
	}


	@warn_unused_result
	public func firstMatchForRegularExpression(regularExpressionPattern: String) -> [String?]? {
		do {
			let regularExpression = try NSRegularExpression(pattern: regularExpressionPattern, options: [])
			return firstMatchForRegularExpression(regularExpression)
		}
		catch let error {
			fatalError("Invalid regular expression pattern: \(error)")
		}
	}


	@warn_unused_result
	public func firstSubstringMatchingRegularExpression(regularExpressionPattern: String) -> String? {
		if let range = rangeOfString(regularExpressionPattern, options: .RegularExpressionSearch) {
			return self[range]
		}

		return nil
	}


	@warn_unused_result
	public func stringByReplacingRegularExpression(regularExpression: NSRegularExpression, withTemplate template: String) -> String {
		return regularExpression.stringByReplacingMatchesInString(self, options: [], range: NSMakeRange(0, utf16.count), withTemplate: template)
	}


	@warn_unused_result
	public func stringByReplacingRegularExpression(regularExpressionPattern: String, withTemplate template: String) -> String {
		do {
			let regularExpression = try NSRegularExpression(pattern: regularExpressionPattern, options: NSRegularExpressionOptions.DotMatchesLineSeparators)
			return stringByReplacingRegularExpression(regularExpression, withTemplate: template)
		}
		catch let error {
			fatalError("Invalid regular expression pattern: \(error)")
		}
	}


	public var urlEncodedHost: String {
		return stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet()) ?? "<url encoding failed>"
	}


	public var urlEncodedPath: String {
		return stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathAllowedCharacterSet()) ?? "<url encoding failed>"
	}


	public var urlEncodedPathComponent: String {
		return stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathComponentAllowedCharacterSet()) ?? "<url encoding failed>"
	}


	public var urlEncodedQuery: String {
		return stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) ?? "<url encoding failed>"
	}


	public var urlEncodedQueryParameter: String {
		return stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryParameterAllowedCharacterSet()) ?? "<url encoding failed>"
	}
}

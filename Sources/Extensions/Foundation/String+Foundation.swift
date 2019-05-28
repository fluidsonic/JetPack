import Foundation


public extension String {

	func firstMatchForRegularExpression(_ regularExpression: NSRegularExpression) -> [Substring?]? {
		guard let match = regularExpression.firstMatch(in: self, options: [], range: NSMakeRange(0, utf16.count)) else {
			return nil
		}

		return (0 ..< match.numberOfRanges).map { match.range(at: $0).rangeInString(self).map { self[$0] } }
	}


	func firstMatchForRegularExpression(_ regularExpressionPattern: String) -> [Substring?]? {
		do {
			let regularExpression = try NSRegularExpression(pattern: regularExpressionPattern, options: [])
			return firstMatchForRegularExpression(regularExpression)
		}
		catch let error {
			fatalError("Invalid regular expression pattern: \(error)")
		}
	}


	func firstSubstringMatchingRegularExpression(_ regularExpressionPattern: String) -> Substring? {
		if let range = range(of: regularExpressionPattern, options: .regularExpression) {
			return self[range]
		}

		return nil
	}


	func stringByReplacingRegularExpression(_ regularExpression: NSRegularExpression, withTemplate template: String) -> String {
		return regularExpression.stringByReplacingMatches(in: self, options: [], range: NSMakeRange(0, utf16.count), withTemplate: template)
	}


	func stringByReplacingRegularExpression(_ regularExpressionPattern: String, withTemplate template: String) -> String {
		do {
			let regularExpression = try NSRegularExpression(pattern: regularExpressionPattern, options: NSRegularExpression.Options.dotMatchesLineSeparators)
			return stringByReplacingRegularExpression(regularExpression, withTemplate: template)
		}
		catch let error {
			fatalError("Invalid regular expression pattern: \(error)")
		}
	}


	var urlEncodedHost: String {
		var allowedCharacters = CharacterSet.urlHostAllowed
		allowedCharacters.insert(":") // https://bugs.swift.org/projects/SR/issues/SR-5397

		return addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? "<url encoding failed>"
	}


	var urlEncodedPath: String {
		var allowedCharacters = CharacterSet.urlPathAllowed
		allowedCharacters.insert(":") // https://bugs.swift.org/projects/SR/issues/SR-5397

		return addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? "<url encoding failed>"
	}


	var urlEncodedPathComponent: String {
		return addingPercentEncoding(withAllowedCharacters: CharacterSet.URLPathComponentAllowedCharacterSet()) ?? "<url encoding failed>"
	}


	var urlEncodedQuery: String {
		return addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "<url encoding failed>"
	}


	var urlEncodedQueryParameter: String {
		return addingPercentEncoding(withAllowedCharacters: CharacterSet.URLQueryParameterAllowedCharacterSet()) ?? "<url encoding failed>"
	}
}

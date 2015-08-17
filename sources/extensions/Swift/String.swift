import Foundation


public extension String {

	public func contains(string: String) -> Bool {
		return rangeOfString(string) != nil
	}


	public var nonEmpty: String? {
		if isEmpty {
			return nil
		}

		return self
	}


	public func stringByReplacing(regex regex: NSRegularExpression, withTemplate template: String) -> String {
		return regex.stringByReplacingMatchesInString(self, options: [], range: NSMakeRange(0, utf16.count), withTemplate: template)
	}


	public func stringByReplacing(regexPattern regexPattern: String, withTemplate template: String) -> String {
		do {
			let regex = try NSRegularExpression(pattern: regexPattern, options: NSRegularExpressionOptions.DotMatchesLineSeparators)
			return stringByReplacing(regex: regex, withTemplate: template)
		}
		catch let error {
			fatalError("Invalid regular expression pattern: \(error)")
		}
	}
	
	
	public func firstMatchForRegexPattern(regexPattern: String) -> [String] {
		do {
			let regex = try NSRegularExpression(pattern: regexPattern, options: [])
			guard let match = regex.firstMatchInString(self, options: [], range: NSMakeRange(0, utf16.count)) else {
				return []
			}
			
			return (0 ..< match.numberOfRanges).map { self[match.rangeAtIndex($0).rangeInString(self)!] }
		}
		catch let error {
			fatalError("Invalid regular expression pattern: \(error)")
		}
	}


	public func substringByMatchingPattern(pattern: String) -> String? {
		if let range = rangeOfString(pattern, options: .RegularExpressionSearch) {
			return self[range]
		}

		return nil
	}


	public var trimmed: String {
		return stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
	}


	public func trimmedToLength(length: Int) -> String {
		if length <= 0 {
			return ""
		}

		let currentLength = characters.count
		if currentLength <= length {
			return self
		}

		return self[startIndex ..< advance(startIndex, length - 1)] + "…"
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


// compiler cannot implicitly map between NSString and String when at least one of them is (implicitly) optional

public func ==(a: String?, b: NSString?) -> Bool { return (a == (b as String?)) }
public func ==(a: NSString?, b: String?) -> Bool { return ((a as String?) == b) }

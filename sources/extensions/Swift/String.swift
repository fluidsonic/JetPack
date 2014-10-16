import Foundation


extension String {

	func contains(string: String) -> Bool {
		return rangeOfString(string) != nil
	}


	func stringByReplacing(#regex: NSRegularExpression, withTemplate template: String) -> String {
		return regex.stringByReplacingMatchesInString(self, options: nil, range: NSMakeRange(0, utf16Count), withTemplate: template)
	}


	func stringByReplacing(#regexPattern: String, withTemplate template: String) -> String {
		var error: NSError?
		if let regex = NSRegularExpression(pattern: regexPattern, options: NSRegularExpressionOptions.DotMatchesLineSeparators, error: &error) {
			return stringByReplacing(regex: regex, withTemplate: template)
		}

		fatalError("Invalid regular expression pattern.")
	}


	func substringByMatchingPattern(pattern: String) -> String? {
		if let range = rangeOfString(pattern, options: .RegularExpressionSearch) {
			return self[range]
		}

		return nil
	}


	var trimmed: String {
		return stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
	}


	func trimmedToLength(length: Int) -> String {
		if length <= 0 {
			return ""
		}

		let currentLength = countElements(self)
		if currentLength <= length {
			return self
		}

		return self[startIndex ..< advance(startIndex, length)] + "…"
	}


	var urlEncodedPath: String {
		return stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathAllowedCharacterSet()) ?? "<url encoding failed>"
	}


	var urlEncodedPathComponent: String {
		return stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathComponentAllowedCharacterSet()) ?? "<url encoding failed>"
	}


	var urlEncodedQuery: String {
		return stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) ?? "<url encoding failed>"
	}


	var urlEncodedQueryParameter: String {
		return stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryParameterAllowedCharacterSet()) ?? "<url encoding failed>"
	}
}


// compiler cannot implicitly map between NSString and String when at least one of them is (implicitly) optional

func ==(a: String?, b: NSString?) -> Bool { return (a == (b as String?)) }
func ==(a: NSString?, b: String?) -> Bool { return ((a as String?) == b) }

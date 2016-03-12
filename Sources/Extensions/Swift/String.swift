import Foundation


public extension String {

	public var nonEmpty: String? {
		if isEmpty {
			return nil
		}

		return self
	}


	@warn_unused_result
	public func trimmedToLength(length: Int, truncationString: String = "") -> String {
		if length <= 0 {
			return ""
		}

		let currentLength = characters.count
		if currentLength <= length {
			return self
		}

		let usableLength = length - truncationString.characters.count
		if usableLength < 0 {
			return truncationString.trimmedToLength(length)
		}
		if usableLength == 0 {
			return truncationString
		}

		return self[startIndex ..< startIndex.advancedBy(usableLength)] + truncationString
	}


	public var whitespaceTrimmed: String {
		return stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
	}
}

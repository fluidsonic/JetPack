import Foundation


public extension String {

	public var nonEmpty: String? {
		if isEmpty {
			return nil
		}

		return self
	}


	
	public func trimmedToLength(_ length: Int, truncationString: String = "") -> String {
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

		return self[startIndex ..< characters.index(startIndex, offsetBy: usableLength)] + truncationString
	}


	public var whitespaceTrimmed: String {
		return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
	}
}

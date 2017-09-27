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

		let currentLength = count
		if currentLength <= length {
			return self
		}

		let usableLength = length - truncationString.count
		if usableLength < 0 {
			return truncationString.trimmedToLength(length)
		}
		if usableLength == 0 {
			return truncationString
		}

		return self[startIndex ..< index(startIndex, offsetBy: usableLength)] + truncationString
	}


	public var whitespaceTrimmed: String {
		return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
	}
}


extension String.SubSequence {

	// allows optional chaining: substring?.toString()
	func toString() -> String {
		return String(self)
	}
}


extension String.UnicodeScalarView {

	public func filterAsView(_ isIncluded: (Iterator.Element) throws -> Bool) rethrows -> String.UnicodeScalarView {
		var view = String.UnicodeScalarView()
		for value in self where try isIncluded(value) {
			view.append(value)
		}

		return view
	}
}

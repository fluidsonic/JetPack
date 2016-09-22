import Foundation


public extension NSMutableAttributedString {

	@nonobjc
	public func appendString(string: String, maintainingPrecedingAttributes: Bool = false, additionalAttributes: [String : AnyObject] = [:]) {
		if maintainingPrecedingAttributes {
			let location = length

			replaceCharactersInRange(NSRange(location: location, length: 0), withString: string)

			if !additionalAttributes.isEmpty {
				addAttributes(additionalAttributes, range: NSRange(location: location, length: length - location))
			}
		}
		else {
			appendAttributedString(NSAttributedString(string: string, attributes: additionalAttributes))
		}
	}


	@nonobjc
	public func transformStringSegments(@noescape transform: (String) -> String) {
		let length = self.length
		guard length > 0 else {
			return
		}

		let escapingTransform = makeEscapable(transform)

		beginEditing()
		enumerateAttributesInRange(NSRange(location: 0, length: length), options: []) { _, range, _ in
			replaceCharactersInRange(range, withString: escapingTransform(attributedSubstringFromRange(range).string))
		}
		endEditing()
	}
}

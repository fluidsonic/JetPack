import Foundation


public extension NSMutableAttributedString {

	@nonobjc
	func append(_ string: String, attributes: [NSAttributedString.Key : Any] = [:], maintainingPrecedingAttributes: Bool = false) {
		if maintainingPrecedingAttributes {
			let location = length

			replaceCharacters(in: NSRange(location: location, length: 0), with: string)

			if !attributes.isEmpty {
				addAttributes(attributes, range: NSRange(location: location, length: length - location))
			}
		}
		else {
			append(NSAttributedString(string: string, attributes: attributes))
		}
	}


	@available(*, deprecated, renamed: "append")
	@nonobjc
	func appendString(_ string: String, maintainingPrecedingAttributes: Bool = false, additionalAttributes: [NSAttributedString.Key : Any] = [:]) {
		if maintainingPrecedingAttributes {
			let location = length

			replaceCharacters(in: NSRange(location: location, length: 0), with: string)

			if !additionalAttributes.isEmpty {
				addAttributes(additionalAttributes, range: NSRange(location: location, length: length - location))
			}
		}
		else {
			append(NSAttributedString(string: string, attributes: additionalAttributes))
		}
	}


	@nonobjc
	func edit(changes: Closure) {
		beginEditing()
		changes()
		endEditing()
	}


	@nonobjc
	func transformStringSegments(_ transform: (String) -> String) {
		let length = self.length
		guard length > 0 else {
			return
		}

		edit {
			enumerateAttributes(in: NSRange(location: 0, length: length), options: []) { _, range, _ in
				replaceCharacters(in: range, with: transform(attributedSubstring(from: range).string))
			}
		}
	}
}

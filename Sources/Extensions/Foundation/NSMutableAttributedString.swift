import Foundation


public extension NSMutableAttributedString {

	@nonobjc
	public func appendString(_ string: String, maintainingPrecedingAttributes: Bool = false, additionalAttributes: [NSAttributedString.Key : Any] = [:]) {
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
	public func edit(changes: Closure) {
		beginEditing()
		changes()
		endEditing()
	}


	@nonobjc
	public func transformStringSegments(_ transform: (String) -> String) {
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

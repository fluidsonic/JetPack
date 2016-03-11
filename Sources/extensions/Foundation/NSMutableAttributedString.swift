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
}

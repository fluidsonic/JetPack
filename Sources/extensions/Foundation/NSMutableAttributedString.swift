import Foundation


public extension NSMutableAttributedString {

	@nonobjc
	public func appendString(string: String) {
		appendString(string, attributes: [:])
	}


	@nonobjc
	public func appendString(string: String, attribute: String, value: AnyObject) {
		let location = length

		replaceCharactersInRange(NSRange(location: location, length: 0), withString: string)
		addAttribute(attribute, value: value, range: NSRange(location: location, length: length - location))
	}


	@nonobjc
	public func appendString(string: String, attributes: [String : AnyObject]) {
		let location = length

		replaceCharactersInRange(NSRange(location: location, length: 0), withString: string)

		if !attributes.isEmpty {
			addAttributes(attributes, range: NSRange(location: location, length: length - location))
		}
	}
}

import Foundation
import UIKit


public extension NSMutableAttributedString {

	public func appendString(string: String) {
		appendString(string, attributes: [:])
	}


	public func appendString(string: String, attribute: String, value: AnyObject) {
		let location = length

		replaceCharactersInRange(NSRange(location: location, length: 0), withString: string)
		addAttribute(attribute, value: value, range: NSRange(location: location, length: length - location))
	}


	public func appendString(string: String, color: UIColor) {
		appendString(string, attribute: NSForegroundColorAttributeName, value: color)
	}


	public func appendString(string: String, color: UIColor, font: UIFont) {
		appendString(string, attributes: [
			NSFontAttributeName:            font,
			NSForegroundColorAttributeName: color,
		])
	}


	public func appendString(string: String, attributes: [NSObject : AnyObject]) {
		let location = length

		replaceCharactersInRange(NSRange(location: location, length: 0), withString: string)

		if !attributes.isEmpty {
			addAttributes(attributes, range: NSRange(location: location, length: length - location))
		}
	}
}

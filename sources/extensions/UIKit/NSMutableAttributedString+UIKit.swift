import UIKit


public extension NSMutableAttributedString {

	@nonobjc
	public func appendString(string: String, color: UIColor) {
		appendString(string, attribute: NSForegroundColorAttributeName, value: color)
	}


	@nonobjc
	public func appendString(string: String, color: UIColor, font: UIFont) {
		appendString(string, attributes: [
			NSFontAttributeName:            font,
			NSForegroundColorAttributeName: color,
		])
	}
}

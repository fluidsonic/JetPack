import UIKit


public extension NSMutableAttributedString {

	@nonobjc
	private func _appendString(string: String,
	                           maintainingPrecedingAttributes: Bool = false,
	                           font: UIFont? = nil,
	                           foregroundColor: UIColor? = nil,
	                           link: NSURL? = nil)
	{
		var attributes = [String : AnyObject]()
		if let font = font {
			attributes[NSFontAttributeName] = font
		}
		if let foregroundColor = foregroundColor {
			attributes[NSForegroundColorAttributeName] = foregroundColor
		}
		if let link = link {
			attributes[NSLinkAttributeName] = link
		}

		appendString(string, maintainingPrecedingAttributes: maintainingPrecedingAttributes, additionalAttributes: attributes)
	}


	@nonobjc
	public func appendString(string: String,
	                         maintainingPrecedingAttributes: Bool = false,
	                         font: UIFont?,
	                         foregroundColor: UIColor? = nil,
	                         link: NSURL? = nil)
	{
		_appendString(string, maintainingPrecedingAttributes: maintainingPrecedingAttributes, font: font, foregroundColor: foregroundColor, link: link)
	}


	@nonobjc
	public func appendString(string: String,
	                         maintainingPrecedingAttributes: Bool = false,
	                         foregroundColor: UIColor?,
	                         link: NSURL? = nil)
	{
		_appendString(string, maintainingPrecedingAttributes: maintainingPrecedingAttributes, font: nil, foregroundColor: foregroundColor, link: link)
	}


	@nonobjc
	public func appendString(string: String,
	                         maintainingPrecedingAttributes: Bool = false,
	                         link: NSURL?)
	{
		_appendString(string, maintainingPrecedingAttributes: maintainingPrecedingAttributes, font: nil, foregroundColor: nil, link: link)
	}
}

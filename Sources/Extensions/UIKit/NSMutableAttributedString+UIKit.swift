import UIKit


public extension NSMutableAttributedString {

	@nonobjc
	private func _appendString(string: String,
	                           maintainingPrecedingAttributes: Bool = false,
	                           font: UIFont?,
	                           foregroundColor: UIColor?,
	                           link: NSURL?,
	                           paragraphStyle: NSParagraphStyle?)
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
		if let paragraphStyle = paragraphStyle {
			attributes[NSParagraphStyleAttributeName] = paragraphStyle
		}

		appendString(string, maintainingPrecedingAttributes: maintainingPrecedingAttributes, additionalAttributes: attributes)
	}


	@nonobjc
	public func appendString(string: String,
	                         maintainingPrecedingAttributes: Bool = false,
	                         font: UIFont?,
	                         foregroundColor: UIColor? = nil,
	                         link: NSURL? = nil,
	                         paragraphStyle: NSParagraphStyle? = nil)
	{
		_appendString(string, maintainingPrecedingAttributes: maintainingPrecedingAttributes, font: font, foregroundColor: foregroundColor, link: link, paragraphStyle: paragraphStyle)
	}


	@nonobjc
	public func appendString(string: String,
	                         maintainingPrecedingAttributes: Bool = false,
	                         foregroundColor: UIColor?,
	                         link: NSURL? = nil,
	                         paragraphStyle: NSParagraphStyle? = nil)
	{
		_appendString(string, maintainingPrecedingAttributes: maintainingPrecedingAttributes, font: nil, foregroundColor: foregroundColor, link: link, paragraphStyle: paragraphStyle)
	}


	@nonobjc
	public func appendString(string: String,
	                         maintainingPrecedingAttributes: Bool = false,
	                         link: NSURL?,
	                         paragraphStyle: NSParagraphStyle? = nil)
	{
		_appendString(string, maintainingPrecedingAttributes: maintainingPrecedingAttributes, font: nil, foregroundColor: nil, link: link, paragraphStyle: paragraphStyle)
	}


	@nonobjc
	public func appendString(string: String,
	                         maintainingPrecedingAttributes: Bool = false,
	                         paragraphStyle: NSParagraphStyle?)
	{
		_appendString(string, maintainingPrecedingAttributes: maintainingPrecedingAttributes, font: nil, foregroundColor: nil, link: nil, paragraphStyle: paragraphStyle)
	}
}

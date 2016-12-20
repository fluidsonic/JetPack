import UIKit


public extension NSMutableAttributedString {

	@nonobjc
	fileprivate func _appendString(_ string: String,
	                           maintainingPrecedingAttributes: Bool = false,
	                           font: UIFont?,
	                           foregroundColor: UIColor?,
	                           link: URL?,
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
			attributes[NSLinkAttributeName] = link as AnyObject?
		}
		if let paragraphStyle = paragraphStyle {
			attributes[NSParagraphStyleAttributeName] = paragraphStyle
		}

		appendString(string, maintainingPrecedingAttributes: maintainingPrecedingAttributes, additionalAttributes: attributes)
	}


	@nonobjc
	public func appendString(_ string: String,
	                         maintainingPrecedingAttributes: Bool = false,
	                         font: UIFont?,
	                         foregroundColor: UIColor? = nil,
	                         link: URL? = nil,
	                         paragraphStyle: NSParagraphStyle? = nil)
	{
		_appendString(string, maintainingPrecedingAttributes: maintainingPrecedingAttributes, font: font, foregroundColor: foregroundColor, link: link, paragraphStyle: paragraphStyle)
	}


	@nonobjc
	public func appendString(_ string: String,
	                         maintainingPrecedingAttributes: Bool = false,
	                         foregroundColor: UIColor?,
	                         link: URL? = nil,
	                         paragraphStyle: NSParagraphStyle? = nil)
	{
		_appendString(string, maintainingPrecedingAttributes: maintainingPrecedingAttributes, font: nil, foregroundColor: foregroundColor, link: link, paragraphStyle: paragraphStyle)
	}


	@nonobjc
	public func appendString(_ string: String,
	                         maintainingPrecedingAttributes: Bool = false,
	                         link: URL?,
	                         paragraphStyle: NSParagraphStyle? = nil)
	{
		_appendString(string, maintainingPrecedingAttributes: maintainingPrecedingAttributes, font: nil, foregroundColor: nil, link: link, paragraphStyle: paragraphStyle)
	}


	@nonobjc
	public func appendString(_ string: String,
	                         maintainingPrecedingAttributes: Bool = false,
	                         paragraphStyle: NSParagraphStyle?)
	{
		_appendString(string, maintainingPrecedingAttributes: maintainingPrecedingAttributes, font: nil, foregroundColor: nil, link: nil, paragraphStyle: paragraphStyle)
	}
}

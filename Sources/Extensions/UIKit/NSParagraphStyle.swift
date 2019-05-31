import UIKit


public extension NSParagraphStyle {

	static func build(_ build: (_ builder: NSMutableParagraphStyle) -> Void) -> NSParagraphStyle {
		let builder = NSMutableParagraphStyle()
		build(builder)
		return builder
	}
}


extension NSParagraphStyle {

	public func effectiveLineHeight(for lineHeight: CGFloat) -> CGFloat {
		var effectiveLineHeight = lineHeight
		if lineHeightMultiple > 0 {
			effectiveLineHeight *= lineHeightMultiple
		}
		if minimumLineHeight > 0 {
			effectiveLineHeight = lineHeight.coerced(atLeast: minimumLineHeight)
		}
		if maximumLineHeight > 0 {
			effectiveLineHeight = lineHeight.coerced(atMost: maximumLineHeight)
		}

		return effectiveLineHeight
	}
}

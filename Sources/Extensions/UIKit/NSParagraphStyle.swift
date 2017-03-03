import UIKit


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

import UIKit


public extension UITableViewCell {

	@objc(JetPack_contentFrameForBounds:)
	private final func private_contentFrameForBounds(bounds: CGRect) -> CGRect {
		// default implementation in case the private method was removed
		return bounds
	}


	@nonobjc
	public final func contentFrameForSize(size: CGSize) -> CGRect {
		return private_contentFrameForBounds(CGRect(size: size))
	}


	@nonobjc
	internal static func UITableViewCell_setUp() {
		// yep, private API necessary :(
		// UIKit doesn't let us properly implement sizeThatFits() in UITableViewCell subclasses because we're unable to determine the correct size of contentView.
		redirectMethodInType(self, fromSelector: "JetPack_contentFrameForBounds:", toSelector: obfuscatedSelector("content", "Rect", "For", "Bounds:"))
	}
}

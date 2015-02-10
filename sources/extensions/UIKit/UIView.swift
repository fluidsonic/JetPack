import UIKit


public extension UIView {

	public func heightThatFits() -> CGFloat {
		return sizeThatFits(CGSize.maxSize).height
	}


	public func heightThatFitsWidth(width: CGFloat) -> CGFloat {
		return sizeThatFits(CGSize(width: width, height: CGFloat.max)).height
	}


	public func removeAllSubviews() {
		for subview in reverse(subviews) {
			subview.removeFromSuperview()
		}
	}


	public func sizeThatFits() -> CGSize {
		return sizeThatFits(CGSize.maxSize)
	}

	
	public func sizeThatFitsHeight(height: CGFloat) -> CGSize {
		return sizeThatFits(CGSize(width: CGFloat.max, height: height))
	}


	public func sizeThatFitsWidth(width: CGFloat) -> CGSize {
		return sizeThatFits(CGSize(width: width, height: CGFloat.max))
	}


	public func widthThatFits() -> CGFloat {
		return sizeThatFits(CGSize.maxSize).width
	}


	public func widthThatFitsHeight(height: CGFloat) -> CGFloat {
		return sizeThatFits(CGSize(width: CGFloat.max, height: height)).width
	}
}

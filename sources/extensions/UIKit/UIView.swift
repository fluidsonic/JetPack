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


	@objc(_roundScaled_CGFloat:)
	public func roundScaled(value: CGFloat) -> CGFloat {
		let scale = contentScaleFactor

		return round(value * scale) / scale
	}


	@objc(_roundScaled_CGSize:)
	public func roundScaled(value: CGSize) -> CGSize {
		let scale = contentScaleFactor

		return CGSize(
			width:  round(value.width * scale) / scale,
			height: round(value.height * scale) / scale
		)
	}


	@objc(_roundScaled_CGRect:)
	public func roundScaled(value: CGRect) -> CGRect {
		let scale = contentScaleFactor

		return CGRect(
			left:   round(value.left * scale) / scale,
			top:    round(value.top * scale) / scale,
			width:  round(value.width * scale) / scale,
			height: round(value.height * scale) / scale
		)
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

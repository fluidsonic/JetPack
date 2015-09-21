public extension UIView {

	@warn_unused_result
	public final func heightThatFits() -> CGFloat {
		return sizeThatFitsSize(.max).height
	}


	@warn_unused_result
	public final func heightThatFitsWidth(maximumWidth: CGFloat) -> CGFloat {
		return sizeThatFitsSize(CGSize(width: maximumWidth, height: .max)).height
	}


	public func removeAllSubviews() {
		for subview in subviews.reverse() {
			subview.removeFromSuperview()
		}
	}


	@nonobjc
	@warn_unused_result
	public final func roundScaled(value: CGFloat) -> CGFloat {
		let scale = contentScaleFactor

		return round(value * scale) / scale
	}


	@nonobjc
	@warn_unused_result
	public final func roundScaled(value: CGPoint) -> CGPoint {
		let scale = contentScaleFactor

		return CGPoint(
			left: round(value.left * scale) / scale,
			top:  round(value.top * scale) / scale
		)
	}


	@nonobjc
	@warn_unused_result
	public final func roundScaled(value: CGSize) -> CGSize {
		let scale = contentScaleFactor

		return CGSize(
			width:  round(value.width * scale) / scale,
			height: round(value.height * scale) / scale
		)
	}


	@nonobjc
	@warn_unused_result
	public final func roundScaled(value: CGRect) -> CGRect {
		let scale = contentScaleFactor

		return CGRect(
			left:   round(value.left * scale) / scale,
			top:    round(value.top * scale) / scale,
			width:  round(value.width * scale) / scale,
			height: round(value.height * scale) / scale
		)
	}


	@warn_unused_result
	public final func sizeThatFits() -> CGSize {
		return sizeThatFitsSize(.max)
	}


	@warn_unused_result
	public final func sizeThatFitsHeight(maximumHeight: CGFloat, allowsTruncation: Bool = false) -> CGSize {
		return sizeThatFitsSize(CGSize(width: .max, height: maximumHeight), allowsTruncation: allowsTruncation)
	}


	@warn_unused_result
	public final func sizeThatFitsWidth(maximumWidth: CGFloat, allowsTruncation: Bool = false) -> CGSize {
		return sizeThatFitsSize(CGSize(width: maximumWidth, height: .max), allowsTruncation: allowsTruncation)
	}


	@warn_unused_result
	public func sizeThatFitsSize(maximumSize: CGSize) -> CGSize {
		return sizeThatFitsSize(maximumSize, allowsTruncation: false)
	}


	@warn_unused_result
	public func sizeThatFitsSize(maximumSize: CGSize, allowsTruncation: Bool) -> CGSize {
		var fittingSize = sizeThatFits(maximumSize)
		if allowsTruncation {
			fittingSize = fittingSize.constrainTo(maximumSize)
		}

		return fittingSize
	}


	@warn_unused_result
	public final func widthThatFits() -> CGFloat {
		return sizeThatFitsSize(.max).width
	}


	@warn_unused_result
	public final func widthThatFitsHeight(maximumHeight: CGFloat) -> CGFloat {
		return sizeThatFitsSize(CGSize(width: .max, height: maximumHeight)).width
	}
}

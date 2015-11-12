import UIKit


public extension UIView {

	@nonobjc
	@warn_unused_result
	public final func alignToGrid(rect: CGRect) -> CGRect {
		return CGRect(origin: alignToGrid(rect.origin), size: alignToGrid(rect.size))
	}


	@nonobjc
	@warn_unused_result
	public final func alignToGrid(point: CGPoint) -> CGPoint {
		return CGPoint(left: roundToGrid(point.left), top: roundToGrid(point.top))
	}


	@nonobjc
	@warn_unused_result
	public final func alignToGrid(size: CGSize) -> CGSize {
		return CGSize(width: ceilToGrid(size.width), height: ceilToGrid(size.height))
	}


	@nonobjc
	@warn_unused_result
	public final func ceilToGrid(value: CGFloat) -> CGFloat {
		let scale = gridScaleFactor
		return ceil(value * scale) / scale
	}


	@nonobjc
	@warn_unused_result
	public final func floorToGrid(value: CGFloat) -> CGFloat {
		let scale = gridScaleFactor
		return floor(value * scale) / scale
	}


	@nonobjc
	public final var gridScaleFactor: CGFloat {
		return max(contentScaleFactor, (window?.screen.scale ?? UIScreen.mainScreen().scale))
	}


	@nonobjc
	@warn_unused_result
	public final func heightThatFits() -> CGFloat {
		return sizeThatFitsSize(.max).height
	}


	@nonobjc
	@warn_unused_result
	public final func heightThatFitsWidth(maximumWidth: CGFloat) -> CGFloat {
		return sizeThatFitsSize(CGSize(width: maximumWidth, height: .max)).height
	}


	@nonobjc
	public var needsLayout: Bool {
		return layer.needsLayout()
	}


	@nonobjc
	public var participatesInHitTesting: Bool {
		return (!hidden && userInteractionEnabled && alpha >= 0.01)
	}


	@nonobjc
	public func removeAllSubviews() {
		for subview in subviews.reverse() {
			subview.removeFromSuperview()
		}
	}


	@nonobjc
	@warn_unused_result
	public final func roundToGrid(value: CGFloat) -> CGFloat {
		let scale = gridScaleFactor
		return round(value * scale) / scale
	}


	@nonobjc
	@warn_unused_result
	public final func sizeThatFits() -> CGSize {
		return sizeThatFitsSize(.max)
	}


	@nonobjc
	@warn_unused_result
	public final func sizeThatFitsHeight(maximumHeight: CGFloat, allowsTruncation: Bool = false) -> CGSize {
		return sizeThatFitsSize(CGSize(width: .max, height: maximumHeight), allowsTruncation: allowsTruncation)
	}


	@nonobjc
	@warn_unused_result
	public final func sizeThatFitsWidth(maximumWidth: CGFloat, allowsTruncation: Bool = false) -> CGSize {
		return sizeThatFitsSize(CGSize(width: maximumWidth, height: .max), allowsTruncation: allowsTruncation)
	}


	// @nonobjc // cannot be used due to compiler limitation: subclasses cannot override non-objc functions defined in extensions
	@warn_unused_result
	public func sizeThatFitsSize(maximumSize: CGSize) -> CGSize {
		return sizeThatFits(maximumSize)
	}


	@nonobjc
	@warn_unused_result
	public final func sizeThatFitsSize(maximumSize: CGSize, allowsTruncation: Bool) -> CGSize {
		var fittingSize = sizeThatFitsSize(maximumSize)
		if allowsTruncation {
			fittingSize = fittingSize.constrainTo(maximumSize)
		}

		return fittingSize
	}


	@nonobjc
	@warn_unused_result
	public final func widthThatFits() -> CGFloat {
		return sizeThatFitsSize(.max).width
	}


	@nonobjc
	@warn_unused_result
	public final func widthThatFitsHeight(maximumHeight: CGFloat) -> CGFloat {
		return sizeThatFitsSize(CGSize(width: .max, height: maximumHeight)).width
	}
}



extension UIViewAnimationCurve: CustomStringConvertible {

	public var description: String {
		switch self.rawValue {
		case EaseIn.rawValue:    return "UIViewAnimationCurve.EaseIn"
		case EaseInOut.rawValue: return "UIViewAnimationCurve.EaseInOut"
		case EaseOut.rawValue:   return "UIViewAnimationCurve.EaseOut"
		case Linear.rawValue:    return "UIViewAnimationCurve.Linear"
		default:                 return "UIViewAnimationCurve(\(rawValue))"
		}
	}
}



public extension UIViewAnimationOptions {

	public init(curve: UIViewAnimationCurve) {
		self.init(rawValue: UInt((curve.rawValue & 7) << 16))
	}


	public var curve: UIViewAnimationCurve {
		return UIViewAnimationCurve(rawValue: Int((rawValue >> 16) & 7))!
	}
}


extension UIViewAnimationOptions: CustomStringConvertible {

	public var description: String {
		var options = [String]()
		if contains(.AllowAnimatedContent) {
			options.append("AllowAnimatedContent")
		}
		if contains(.AllowUserInteraction) {
			options.append("AllowUserInteraction")
		}
		if contains(.Autoreverse) {
			options.append("Autoreverse")
		}
		if contains(.BeginFromCurrentState) {
			options.append("BeginFromCurrentState")
		}
		switch curve.rawValue {
		case UIViewAnimationCurve.EaseIn.rawValue:    options.append("CurveEaseIn")
		case UIViewAnimationCurve.EaseInOut.rawValue: options.append("CurveEaseInOut")
		case UIViewAnimationCurve.EaseOut.rawValue:   options.append("CurveEaseOut")
		case UIViewAnimationCurve.Linear.rawValue:    options.append("CurveLinear")
		default:                                      options.append("Curve(\(curve.rawValue))")
		}
		if contains(.LayoutSubviews) {
			options.append("LayoutSubviews")
		}
		if contains(.OverrideInheritedCurve) {
			options.append("OverrideInheritedCurve")
		}
		if contains(.OverrideInheritedDuration) {
			options.append("OverrideInheritedDuration")
		}
		if contains(.OverrideInheritedOptions) {
			options.append("OverrideInheritedOptions")
		}
		if contains(.Repeat) {
			options.append("Repeat")
		}
		if contains(.ShowHideTransitionViews) {
			options.append("ShowHideTransitionViews")
		}
		if contains(.TransitionCurlUp) {
			options.append("TransitionCurlUp")
		}
		if contains(.TransitionCurlDown) {
			options.append("TransitionCurlDown")
		}
		if contains(.TransitionCrossDissolve) {
			options.append("TransitionCrossDissolve")
		}
		if contains(.TransitionFlipFromBottom) {
			options.append("TransitionFlipFromBottom")
		}
		if contains(.TransitionFlipFromLeft) {
			options.append("TransitionFlipFromLeft")
		}
		if contains(.TransitionFlipFromRight) {
			options.append("TransitionFlipFromRight")
		}
		if contains(.TransitionFlipFromTop) {
			options.append("TransitionFlipFromTop")
		}

		return "UIViewAnimationOptions(\(options.joinWithSeparator(", ")))"
	}
}

import UIKit

private let dummyView = UIView()


extension UIView {

	@nonobjc
	public final func alignToGrid(_ rect: CGRect) -> CGRect {
		return CGRect(origin: alignToGrid(rect.origin), size: alignToGrid(rect.size))
	}


	@nonobjc
	public final func alignToGrid(_ point: CGPoint) -> CGPoint {
		return CGPoint(left: roundToGrid(point.left), top: roundToGrid(point.top))
	}


	@nonobjc
	public final func alignToGrid(_ size: CGSize) -> CGSize {
		return CGSize(width: ceilToGrid(size.width), height: ceilToGrid(size.height))
	}


	@nonobjc
	public final func ceilToGrid(_ value: CGFloat) -> CGFloat {
		return UIView.roundUpIgnoringErrors(value, increment: 1 / gridScaleFactor)
	}


	@nonobjc
	public static func defaultActionForLayer(_ layer: CALayer, forKey key: String) -> CAAction? {
		guard key != "delegate" else {
			return nil
		}

		let dummyLayer = dummyView.layer

		let layerDelegate = layer.delegate
		layer.delegate = dummyView
		defer { layer.delegate = layerDelegate }

		return layer.action(forKey: key)
	}


	@nonobjc
	public final var delegateViewController: UIViewController? {
		// this or private API…
		return next as? UIViewController
	}


	@nonobjc
	public final func floorToGrid(_ value: CGFloat) -> CGFloat {
		return UIView.roundDownIgnoringErrors(value, increment: 1 / gridScaleFactor)
	}


	@nonobjc
	public func frameWhenApplyingTransform(_ transform: CGAffineTransform) -> CGRect {
		return untransformedFrame.applying(transform, anchorPoint: layer.anchorPoint)
	}


	@nonobjc
	public final var gridScaleFactor: CGFloat {
		return max(contentScaleFactor, (window?.screen.scale ?? UIScreen.main.scale))
	}


	@nonobjc
	public final func heightThatFits() -> CGFloat {
		return sizeThatFitsSize(.max).height
	}


	@nonobjc
	public final func heightThatFitsWidth(_ maximumWidth: CGFloat) -> CGFloat {
		return sizeThatFitsSize(CGSize(width: maximumWidth, height: .greatestFiniteMagnitude)).height
	}


	@nonobjc
	public var needsLayout: Bool {
		return layer.needsLayout()
	}


	@nonobjc
	public var participatesInHitTesting: Bool {
		return (!isHidden && isUserInteractionEnabled && alpha >= 0.01)
	}


	@nonobjc
	public func pixelsForPoints(_ points: CGFloat) -> CGFloat {
		return points * gridScaleFactor
	}


	@nonobjc
	public func pointsForPixels(_ pixels: CGFloat) -> CGFloat {
		return pixels / gridScaleFactor
	}


	@nonobjc
	public func recursivelyFindSubviewOfType <ViewType: UIView>(_ type: ViewType.Type) -> ViewType? {
		for subview in subviews {
			if let subview = subview as? ViewType ?? subview.recursivelyFindSubviewOfType(type) {
				return subview
			}
		}

		return nil
	}


	@nonobjc
	public func recursivelyFindSuperviewOfType <ViewType: UIView>(_ type: ViewType.Type) -> ViewType? {
		var view = self
		while let superview = view.superview {
			if let superview = superview as? ViewType {
				return superview
			}

			view = superview
		}

		return nil
	}


	@nonobjc
	public func removeAllSubviews() {
		for subview in subviews.reversed() {
			subview.removeFromSuperview()
		}
	}


	@nonobjc
	private static func roundDownIgnoringErrors(_ value: CGFloat, increment: CGFloat) -> CGFloat {
		var value = value
		value += (5 * value.ulp)

		return value.rounded(.down, increment: increment)
	}


	@nonobjc
	private static func roundUpIgnoringErrors(_ value: CGFloat, increment: CGFloat) -> CGFloat {
		var value = value
		value -= (5 * value.ulp)

		return value.rounded(.up, increment: increment)
	}


	@nonobjc
	public final func roundToGrid(_ value: CGFloat) -> CGFloat {
		return value.rounded(increment: 1 / gridScaleFactor)
	}


	@nonobjc
	public final func sizeThatFits() -> CGSize {
		return sizeThatFitsSize(.max)
	}


	@nonobjc
	public final func sizeThatFitsHeight(_ maximumHeight: CGFloat, allowsTruncation: Bool = false) -> CGSize {
		return sizeThatFitsSize(CGSize(width: .greatestFiniteMagnitude, height: maximumHeight), allowsTruncation: allowsTruncation)
	}


	@nonobjc
	public final func sizeThatFitsWidth(_ maximumWidth: CGFloat, allowsTruncation: Bool = false) -> CGSize {
		return sizeThatFitsSize(CGSize(width: maximumWidth, height: .greatestFiniteMagnitude), allowsTruncation: allowsTruncation)
	}


	@objc(JetPack_sizeThatFitsSize:)
	public func sizeThatFitsSize(_ maximumSize: CGSize) -> CGSize {
		return sizeThatFits(maximumSize)
	}


	@nonobjc
	public final func sizeThatFitsSize(_ maximumSize: CGSize, allowsTruncation: Bool) -> CGSize {
		var fittingSize = sizeThatFitsSize(maximumSize)
		if allowsTruncation {
			fittingSize = fittingSize.coerced(atMost: maximumSize)
		}

		return fittingSize
	}


	@objc(JetPack_subviewDidInvalidateIntrinsicContentSize:)
	open func subviewDidInvalidateIntrinsicContentSize(_ view: UIView) {
		// override in subclasses
	}


	@objc(JetPack_didChangeFromWindow:toWindow:)
	fileprivate dynamic func swizzled_didChangeWindow(from: UIWindow?, to: UIWindow?) {
		swizzled_didChangeWindow(from: from, to: to)

		delegateViewController?.viewDidMoveToWindow()
	}


	@objc(JetPack_invalidateIntrinsicContentSize_needingLayout:)
	fileprivate dynamic func swizzled_invalidateIntrinsicContentSizeNeedingLayout(_ needsLayout: Bool) {
		swizzled_invalidateIntrinsicContentSizeNeedingLayout(needsLayout)

		superview?.subviewDidInvalidateIntrinsicContentSize(self)
	}


	@objc(JetPack_removeAllAnimations:)
	fileprivate dynamic func swizzled_removeAllAnimations(_ arg1: Bool) {
		guard !CALayer.removeAllAnimationsCallsAreDisabled else {
			return
		}

		swizzled_removeAllAnimations(arg1)
	}


	@nonobjc
	public var untransformedFrame: CGRect {
		get {
			let size = bounds.size
			let anchorPoint = layer.anchorPoint
			let centerOffset = CGPoint(left: (0.5 - anchorPoint.left) * size.width, top: (0.5 - anchorPoint.top) * size.height)

			return CGRect(size: size).centered(at: center.offsetBy(centerOffset))
		}
		set {
			let anchorPoint = layer.anchorPoint
			let centerOffset = CGPoint(left: (0.5 - anchorPoint.left) * -newValue.width, top: (0.5 - anchorPoint.top) * -newValue.height)

			bounds = CGRect(origin: bounds.origin, size: newValue.size)
			center = newValue.center.offsetBy(centerOffset)
		}
	}


	@nonobjc
	public final func widthThatFits() -> CGFloat {
		return sizeThatFitsSize(.max).width
	}


	@nonobjc
	public final func widthThatFitsHeight(_ maximumHeight: CGFloat) -> CGFloat {
		return sizeThatFitsSize(CGSize(width: .greatestFiniteMagnitude, height: maximumHeight)).width
	}
}



extension UIViewAnimationCurve: CustomStringConvertible {

	public var description: String {
		switch self.rawValue {
		case UIViewAnimationCurve.easeIn.rawValue:    return "UIViewAnimationCurve.EaseIn"
		case UIViewAnimationCurve.easeInOut.rawValue: return "UIViewAnimationCurve.EaseInOut"
		case UIViewAnimationCurve.easeOut.rawValue:   return "UIViewAnimationCurve.EaseOut"
		case UIViewAnimationCurve.linear.rawValue:    return "UIViewAnimationCurve.Linear"
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
		if contains(.allowAnimatedContent) {
			options.append("AllowAnimatedContent")
		}
		if contains(.allowUserInteraction) {
			options.append("AllowUserInteraction")
		}
		if contains(.autoreverse) {
			options.append("Autoreverse")
		}
		if contains(.beginFromCurrentState) {
			options.append("BeginFromCurrentState")
		}
		switch curve.rawValue {
		case UIViewAnimationCurve.easeIn.rawValue:    options.append("CurveEaseIn")
		case UIViewAnimationCurve.easeInOut.rawValue: options.append("CurveEaseInOut")
		case UIViewAnimationCurve.easeOut.rawValue:   options.append("CurveEaseOut")
		case UIViewAnimationCurve.linear.rawValue:    options.append("CurveLinear")
		default:                                      options.append("Curve(\(curve.rawValue))")
		}
		if contains(.layoutSubviews) {
			options.append("LayoutSubviews")
		}
		if contains(.overrideInheritedCurve) {
			options.append("OverrideInheritedCurve")
		}
		if contains(.overrideInheritedDuration) {
			options.append("OverrideInheritedDuration")
		}
		if contains(.overrideInheritedOptions) {
			options.append("OverrideInheritedOptions")
		}
		if contains(.repeat) {
			options.append("Repeat")
		}
		if contains(.showHideTransitionViews) {
			options.append("ShowHideTransitionViews")
		}
		if contains(.transitionCurlUp) {
			options.append("TransitionCurlUp")
		}
		if contains(.transitionCurlDown) {
			options.append("TransitionCurlDown")
		}
		if contains(.transitionCrossDissolve) {
			options.append("TransitionCrossDissolve")
		}
		if contains(.transitionFlipFromBottom) {
			options.append("TransitionFlipFromBottom")
		}
		if contains(.transitionFlipFromLeft) {
			options.append("TransitionFlipFromLeft")
		}
		if contains(.transitionFlipFromRight) {
			options.append("TransitionFlipFromRight")
		}
		if contains(.transitionFlipFromTop) {
			options.append("TransitionFlipFromTop")
		}

		return "UIViewAnimationOptions(\(options.joined(separator: ", ")))"
	}
}


extension UIViewTintAdjustmentMode: CustomStringConvertible {

	public var description: String {
		switch self {
		case .automatic: return "UIViewTintAdjustmentMode.Automatic"
		case .dimmed:    return "UIViewTintAdjustmentMode.Dimmed"
		case .normal:    return "UIViewTintAdjustmentMode.Normal"
		}
	}
}


@objc(_JetPack_Extensions_UIKit_UIView_Initialization)
private class StaticInitialization: NSObject, StaticInitializable {

	static func staticInitialize() {
		// cannot use didMoveToWindow() because some subclasses don't call super's implementation
		swizzleMethod(in: UIView.self, from: obfuscatedSelector("_", "did", "Move", "From", "Window:", "to", "Window:"), to: #selector(UIView.swizzled_didChangeWindow(from:to:)))
		swizzleMethod(in: UIView.self, from: obfuscatedSelector("_", "invalidate", "Intrinsic", "Content", "Size", "Needing", "Layout:"), to: #selector(UIView.swizzled_invalidateIntrinsicContentSizeNeedingLayout(_:)))
		swizzleMethod(in: UIView.self, from: obfuscatedSelector("_", "remove", "All", "Animations:"), to: #selector(UIView.swizzled_removeAllAnimations(_:)))
	}
}

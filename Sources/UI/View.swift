import UIKit


@objc(JetPack_View)
public /* non-final */ class View: UIView {

	private static let _dummyView = View()

	private var originalBackgroundColor: UIColor?
	private var originalBorderColor: UIColor?

	public var additionalHitZone = UIEdgeInsets() // TODO don't use UIEdgeInsets becase actually we outset
	public var backgroundColorLocked = false
	public var hitZoneFollowsCornerRadius = true
	public var userInteractionLimitedToSubviews = false


	public init() {
		super.init(frame: .zero)

		clipsToBounds = true
		backgroundColor = super.backgroundColor

		if let layerBorderColor = layer.borderColor {
			borderColor = UIColor(CGColor: layerBorderColor)
		}
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)

		backgroundColor = super.backgroundColor

		if let layerBorderColor = layer.borderColor {
			borderColor = UIColor(CGColor: layerBorderColor)
		}
	}


	public override func actionForLayer(layer: CALayer, forKey event: String) -> CAAction? {
		switch event {
		case "borderColor", "cornerRadius", "shadowColor", "shadowOffset", "shadowOpacity", "shadowPath", "shadowRadius":
			if let animation = super.actionForLayer(layer, forKey: "opacity") as? CABasicAnimation {
				animation.fromValue = layer.valueForKey(event)
				animation.keyPath = event

				return animation
			}

			fallthrough

		default:
			return super.actionForLayer(layer, forKey: event)
		}
	}

	
	public class func animate(duration duration: NSTimeInterval, changes: () -> Void) {
		animateWithDuration(duration, delay: 0, options: [], animations: changes, completion: nil)
	}
	
	
	public class func animate(duration duration: NSTimeInterval, changes: () -> Void, completion: Bool -> Void) {
		animateWithDuration(duration, delay: 0, options: [], animations: changes, completion: completion)
	}
	
	
	public class func animate(duration duration: NSTimeInterval, options: UIViewAnimationOptions, changes: () -> Void) {
		animateWithDuration(duration, delay: 0, options: options, animations: changes, completion: nil)
	}
	
	
	public class func animate(duration duration: NSTimeInterval, options: UIViewAnimationOptions, changes: () -> Void, completion: Bool -> Void) {
		animateWithDuration(duration, delay: 0, options: options, animations: changes, completion: completion)
	}
	
	
	public class func animate(duration duration: NSTimeInterval, options: UIViewAnimationOptions, delay: NSTimeInterval, changes: () -> Void) {
		animateWithDuration(duration, delay: delay, options: options, animations: changes, completion: nil)
	}
	
	
	public class func animate(duration duration: NSTimeInterval, options: UIViewAnimationOptions, delay: NSTimeInterval, changes: () -> Void, completion: Bool -> Void) {
		animateWithDuration(duration, delay: delay, options: options, animations: changes, completion: completion)
	}
	
	
	public class func animate(duration duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, changes: () -> Void) {
		animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: 0, options: [], animations: changes, completion: nil)
	}
	
	
	public class func animate(duration duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, changes: () -> Void, completion: Bool -> Void) {
		animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: 0, options: [], animations: changes, completion: completion)
	}
	
	
	public class func animate(duration duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, options: UIViewAnimationOptions, changes: () -> Void) {
		animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: 0, options: options, animations: changes, completion: nil)
	}
	
	
	public class func animate(duration duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, options: UIViewAnimationOptions, changes: () -> Void, completion: Bool -> Void) {
		animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: 0, options: options, animations: changes, completion: completion)
	}
	
	
	public class func animate(duration duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, options: UIViewAnimationOptions, delay: NSTimeInterval, changes: () -> Void) {
		animateWithDuration(duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: 0, options: options, animations: changes, completion: nil)
	}
	
	
	public class func animate(duration duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, options: UIViewAnimationOptions, delay: NSTimeInterval, changes: () -> Void, completion: Bool -> Void) {
		animateWithDuration(duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: 0, options: options, animations: changes, completion: completion)
	}
	
	
	public class func animate(duration duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, initialSpringVelocity: CGFloat, changes: () -> Void) {
		animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: initialSpringVelocity, options: [], animations: changes, completion: nil)
	}
	
	
	public class func animate(duration duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, initialSpringVelocity: CGFloat, changes: () -> Void, completion: Bool -> Void) {
		animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: initialSpringVelocity, options: [], animations: changes, completion: completion)
	}
	
	
	public class func animate(duration duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, changes: () -> Void) {
		animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: initialSpringVelocity, options: options, animations: changes, completion: nil)
	}
	
	
	public class func animate(duration duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, changes: () -> Void, completion: Bool -> Void) {
		animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: initialSpringVelocity, options: options, animations: changes, completion: completion)
	}
	
	
	public class func animate(duration duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, delay: NSTimeInterval, changes: () -> Void) {
		animateWithDuration(duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: initialSpringVelocity, options: options, animations: changes, completion: nil)
	}
	
	
	public class func animate(duration duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, delay: NSTimeInterval, changes: () -> Void, completion: Bool -> Void) {
		animateWithDuration(duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: initialSpringVelocity, options: options, animations: changes, completion: completion)
	}


	public override var backgroundColor: UIColor? {
		get { return originalBackgroundColor }
		set {
			guard !backgroundColorLocked && newValue != originalBackgroundColor else {
				return
			}

			originalBackgroundColor = newValue

			super.backgroundColor = newValue?.tintedWithColor(tintColor)
		}
	}


	public var borderColor: UIColor? {
		get { return originalBorderColor }
		set {
			guard newValue != originalBorderColor else {
				return
			}

			originalBorderColor = newValue

			layer.borderColor = newValue?.tintedWithColor(tintColor).CGColor
		}
	}


	public var borderWidth: CGFloat {
		get { return layer.borderWidth }
		set { layer.borderWidth = newValue }
	}


	public var cornerRadius: CGFloat {
		get { return layer.cornerRadius }
		set { layer.cornerRadius = newValue }
	}


	public func didResizeFromSize(oldSize: CGSize) {
		// override in subclasses
	}
	

	// reference implementation
	@warn_unused_result
	public override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
		guard participatesInHitTesting else {
			return nil
		}
		guard pointInside(point, withEvent: event) else {
			return nil
		}

		var hitView: UIView?
		for subview in subviews.reverse() {
			hitView = subview.hitTest(convertPoint(point, toView: subview), withEvent: event)
			if hitView != nil {
				break
			}
		}

		if hitView == nil && !userInteractionLimitedToSubviews {
			hitView = self
		}

		return hitView
	}


	// Documentation does not state what the default value is so we define one for View subclasses.
	@warn_unused_result
	public override func intrinsicContentSize() -> CGSize {
		return CGSize(width: UIViewNoIntrinsicMetric, height: UIViewNoIntrinsicMetric)
	}


	@warn_unused_result
	public override class func layerClass() -> AnyObject.Type {
		return Layer.self
	}


	@warn_unused_result
	public final override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
		return pointInside(point, withEvent: event, additionalHitZone: additionalHitZone)
	}


	@warn_unused_result
	public func pointInside(point: CGPoint, withEvent event: UIEvent?, additionalHitZone: UIEdgeInsets) -> Bool {
		let originalHitZone = bounds
		let extendedHitZone = originalHitZone.insetBy(additionalHitZone.inverse)

		let hitZoneCornerRadius: CGFloat
		if hitZoneFollowsCornerRadius {
			if cornerRadius > 0 {
				let halfOriginalHitZoneSize = (originalHitZone.width + originalHitZone.height) / 4  // middle between half height and half width
				let halfExtendedHitZoneSize = (extendedHitZone.width + extendedHitZone.height) / 4  // middle between half extended height and half extended width
				hitZoneCornerRadius = halfExtendedHitZoneSize * (cornerRadius / halfOriginalHitZoneSize)
			}
			else {
				hitZoneCornerRadius = 0
			}
		}
		else {
			hitZoneCornerRadius = cornerRadius
		}

		return extendedHitZone.contains(point, atCornerRadius: hitZoneCornerRadius)
	}


	public var shadowColor: UIColor? {
		get {
			guard let layerShadowColor = layer.shadowColor else {
				return nil
			}

			return UIColor(CGColor: layerShadowColor)
		}
		set {
			layer.shadowColor = newValue?.CGColor
		}
	}


	public var shadowOffset: UIOffset {
		get {
			let layerShadowOffset = layer.shadowOffset
			return UIOffset(horizontal: layerShadowOffset.width, vertical: layerShadowOffset.height)
		}
		set {
			layer.shadowOffset = CGSize(width: newValue.horizontal, height: newValue.vertical)
		}
	}


	public var shadowOpacity: CGFloat {
		get { return CGFloat(layer.shadowOpacity) }
		set { layer.shadowOpacity = Float(newValue) }
	}


	public var shadowPath: UIBezierPath? {
		get {
			guard let layerShadowPath = layer.shadowPath else {
				return nil
			}

			return UIBezierPath(CGPath: layerShadowPath)
		}
		set { layer.shadowPath = newValue?.CGPath }
	}


	public var shadowRadius: CGFloat {
		get { return layer.shadowRadius }
		set { layer.shadowRadius = newValue }
	}


	@warn_unused_result
	public override func sizeThatFitsSize(maximumSize: CGSize) -> CGSize {
		return bounds.size
	}


	// Override `sizeThatFitsSize(_:)` instead!
	@available(*, unavailable, renamed="sizeThatFitsSize")
	@warn_unused_result
	public final override func sizeThatFits(maximumSize: CGSize) -> CGSize {
		return sizeThatFitsSize(maximumSize)
	}


	// Original implementation calls sizeThatFits(_:) with current size instead of maximum size which is nonsense. The parameter represents the size limit and sizeToFit() as per documentation is not limited to any size.
	public override func sizeToFit() {
		var bounds = self.bounds
		bounds.size = sizeThatFits()
		self.bounds = bounds
	}


	public override var tintColor: UIColor! {
		get { return super.tintColor }
		set {
			guard newValue?.tintAlpha == nil else {
				log("Cannot set .tintColor of \(self) to \(newValue). Use `nil` instead.")
				super.tintColor = nil
				return
			}

			super.tintColor = newValue
		}
	}


	public override func tintColorDidChange() {
		super.tintColorDidChange()

		if let originalBackgroundColor = originalBackgroundColor where originalBackgroundColor.tintAlpha != nil {
			super.backgroundColor = originalBackgroundColor.tintedWithColor(tintColor)
		}

		if let originalBorderColor = originalBorderColor where originalBorderColor.tintAlpha != nil {
			layer.borderColor = originalBorderColor.tintedWithColor(tintColor).CGColor
		}
	}


	public func willResizeToSize(newSize: CGSize) {
		// override in subclasses
	}
}

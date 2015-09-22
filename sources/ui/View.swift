@IBDesignable
public /* non-final */ class View: UIView {

	private static let _dummyView = View()

	@IBInspectable
	public var additionalHitZone: UIEdgeInsets = .zero // TODO don't use UIEdgeInsets becase actually we outset
	
	@IBInspectable
	public var backgroundColorLocked: Bool = false

	@IBInspectable
	public var hitZoneFollowsCornerRadius: Bool = true
	
	@IBInspectable
	public var userInteractionLimitedToSubviews: Bool = false
	
	
	public init() {
		super.init(frame: .zero)

		clipsToBounds = true
	}
	
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}


	#if TARGET_INTERFACE_BUILDER
		public required override convenience init(frame: CGRect) {
			self.init()

			self.frame = frame
		}
	#endif

	
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
		get { return super.backgroundColor }
		set {
			if backgroundColorLocked {
				return
			}
			
			super.backgroundColor = newValue
		}
	}


	@IBInspectable
	public var borderColor: UIColor? {
		get {
			guard let borderColor = layer.borderColor else {
				return nil
			}

			return UIColor(CGColor: borderColor)
		}
		set {
			layer.borderColor = newValue?.CGColor
		}
	}


	@IBInspectable
	public var cornerRadius: CGFloat {
		get { return layer.cornerRadius }
		set { layer.cornerRadius = newValue }
	}


	public static var currentAnimation: CAAnimation? {
		let dummy = _dummyView
		let action = dummy.layer.actionForKey("backgroundColor")
		action?.runActionForKey("backgroundColor", object: dummy.layer, arguments: nil)

		return action as? CAAnimation
	}
	
	
	public override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
		let view = super.hitTest(point, withEvent: event)
		if userInteractionLimitedToSubviews && view === self {
			return nil
		}
		
		return view
	}


	// Documentation does not state what the default value is so we define one for View subclasses.
	public override func intrinsicContentSize() -> CGSize {
		return CGSize(width: UIViewNoIntrinsicMetric, height: UIViewNoIntrinsicMetric)
	}


	public final override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
		return pointInside(point, withEvent: event, additionalHitZone: additionalHitZone)
	}


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

		return extendedHitZone.containsPoint(point, atCornerRadius: hitZoneCornerRadius)
	}


	public override func sizeThatFitsSize(maximumSize: CGSize) -> CGSize {
		return bounds.size
	}


	// Override `sizeThatFitsSize(_:)` instead!
	public final override func sizeThatFitsSize(maximumSize: CGSize, allowsTruncation: Bool) -> CGSize {
		var fittingSize = sizeThatFitsSize(maximumSize)
		if allowsTruncation {
			fittingSize = fittingSize.constrainTo(maximumSize)
		}

		return fittingSize
	}


	// Override `sizeThatFitsSize(_:)` instead!
	public final override func sizeThatFits(maximumSize: CGSize) -> CGSize {
		return sizeThatFitsSize(maximumSize, allowsTruncation: false)
	}


	// Original implementation calls sizeThatFits(_:) with current size instead of maximum size which is nonsense. The parameter represents a the size limit and sizeToFit() as per documentation is not limited to any size.
	public override func sizeToFit() {
		var bounds = self.bounds
		bounds.size = sizeThatFits()
		self.bounds = bounds
	}
}

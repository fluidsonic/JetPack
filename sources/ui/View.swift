import UIKit


public class View: UIView {
	
	@IBInspectable
	public var backgroundColorLocked: Bool = false
	
	@IBInspectable
	public var userInteractionLimitedToSubviews: Bool = false
	
	
	public init() {
		super.init(frame: .zero)
	}
	
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
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
		get { return super.backgroundColor }
		set {
			if backgroundColorLocked {
				return
			}
			
			super.backgroundColor = newValue
		}
	}


	@IBInspectable
	public var cornerRadius: CGFloat {
		get { return layer.cornerRadius }
		set { layer.cornerRadius = newValue }
	}
	
	
	public override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
		let view = super.hitTest(point, withEvent: event)
		if userInteractionLimitedToSubviews && view === self {
			return nil
		}
		
		return view
	}
}

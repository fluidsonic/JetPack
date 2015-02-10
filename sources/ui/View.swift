import UIKit


public class View: UIView {

	public override init() {
		super.init(frame: .zeroRect)
	}


	public required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	public class func animate(#duration: NSTimeInterval, animations: () -> Void) {
		animateWithDuration(duration, delay: 0, options: nil, animations: animations, completion: nil)
	}


	public class func animate(#duration: NSTimeInterval, animations: () -> Void, completion: Bool -> Void) {
		animateWithDuration(duration, delay: 0, options: nil, animations: animations, completion: completion)
	}


	public class func animate(#duration: NSTimeInterval, options: UIViewAnimationOptions, animations: () -> Void) {
		animateWithDuration(duration, delay: 0, options: options, animations: animations, completion: nil)
	}


	public class func animate(#duration: NSTimeInterval, options: UIViewAnimationOptions, animations: () -> Void, completion: Bool -> Void) {
		animateWithDuration(duration, delay: 0, options: options, animations: animations, completion: completion)
	}


	public class func animate(#duration: NSTimeInterval, options: UIViewAnimationOptions, delay: NSTimeInterval, animations: () -> Void) {
		animateWithDuration(duration, delay: delay, options: options, animations: animations, completion: nil)
	}


	public class func animate(#duration: NSTimeInterval, options: UIViewAnimationOptions, delay: NSTimeInterval, animations: () -> Void, completion: Bool -> Void) {
		animateWithDuration(duration, delay: delay, options: options, animations: animations, completion: completion)
	}


	public class func animate(#duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, animations: () -> Void) {
		animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: 0, options: nil, animations: animations, completion: nil)
	}


	public class func animate(#duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, animations: () -> Void, completion: Bool -> Void) {
		animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: 0, options: nil, animations: animations, completion: completion)
	}


	public class func animate(#duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, options: UIViewAnimationOptions, animations: () -> Void) {
		animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: 0, options: options, animations: animations, completion: nil)
	}


	public class func animate(#duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, options: UIViewAnimationOptions, animations: () -> Void, completion: Bool -> Void) {		animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: 0, options: options, animations: animations, completion: completion)
	}


	public class func animate(#duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, options: UIViewAnimationOptions, delay: NSTimeInterval, animations: () -> Void) {
		animateWithDuration(duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: 0, options: options, animations: animations, completion: nil)
	}


	public class func animate(#duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, options: UIViewAnimationOptions, delay: NSTimeInterval, animations: () -> Void, completion: Bool -> Void) {
		animateWithDuration(duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: 0, options: options, animations: animations, completion: completion)
	}


	public class func animate(#duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, initialSpringVelocity: CGFloat, animations: () -> Void) {
		animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: initialSpringVelocity, options: nil, animations: animations, completion: nil)
	}


	public class func animate(#duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, initialSpringVelocity: CGFloat, animations: () -> Void, completion: Bool -> Void) {
		animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: initialSpringVelocity, options: nil, animations: animations, completion: completion)
	}


	public class func animate(#duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: () -> Void) {		animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: nil)
	}


	public class func animate(#duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: () -> Void, completion: Bool -> Void) {
		animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
	}

	public class func animate(#duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, delay: NSTimeInterval, animations: () -> Void) {
		animateWithDuration(duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: nil)
	}

	public class func animate(#duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, delay: NSTimeInterval, animations: () -> Void, completion: Bool -> Void) {
		animateWithDuration(duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
	}
}

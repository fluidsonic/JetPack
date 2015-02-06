import UIKit


public extension UIView {

	public class func animate(#duration: NSTimeInterval, animations: () -> Void) {
		animate(duration: duration, options: nil, delay: 0, animations: animations)
	}

	public class func animate(#duration: NSTimeInterval, animations: () -> Void, completion: Bool -> Void) {
		animate(duration: duration, options: nil, delay: 0, animations: animations, completion: completion)
	}

	public class func animate(#duration: NSTimeInterval, options: UIViewAnimationOptions, animations: () -> Void) {
		animate(duration: duration, options: options, delay: 0, animations: animations)
	}

	public class func animate(#duration: NSTimeInterval, options: UIViewAnimationOptions, animations: () -> Void, completion: Bool -> Void) {
		animate(duration: duration, options: options, delay: 0, animations: animations, completion: completion)
	}

	public class func animate(#duration: NSTimeInterval, options: UIViewAnimationOptions, delay: NSTimeInterval, animations: () -> Void) {
		animateWithDuration(duration, delay: delay, options: options, animations: animations, completion: nil)
	}

	public class func animate(#duration: NSTimeInterval, options: UIViewAnimationOptions, delay: NSTimeInterval, animations: () -> Void, completion: Bool -> Void) {
		animateWithDuration(duration, delay: delay, options: options, animations: animations, completion: completion)
	}

	public class func animate(#duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, animations: () -> Void) {
		animate(duration: duration, usingSpringWithDamping: damping, initialSpringVelocity: 0, options: nil, delay: 0, animations: animations)
	}

	public class func animate(#duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, animations: () -> Void, completion: Bool -> Void) {
		animate(duration: duration, usingSpringWithDamping: damping, initialSpringVelocity: 0, options: nil, delay: 0, animations: animations, completion: completion)
	}

	public class func animate(#duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, options: UIViewAnimationOptions, animations: () -> Void) {
		animate(duration: duration, usingSpringWithDamping: damping, initialSpringVelocity: 0, options: options, delay: 0, animations: animations)
	}

	public class func animate(#duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, options: UIViewAnimationOptions, animations: () -> Void, completion: Bool -> Void) {
		animate(duration: duration, usingSpringWithDamping: damping, initialSpringVelocity: 0, options: options, delay: 0, animations: animations, completion: completion)
	}

	public class func animate(#duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, options: UIViewAnimationOptions, delay: NSTimeInterval, animations: () -> Void) {
		animate(duration: duration, usingSpringWithDamping: damping, initialSpringVelocity: 0, options: options, delay: delay, animations: animations)
	}

	public class func animate(#duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, options: UIViewAnimationOptions, delay: NSTimeInterval, animations: () -> Void, completion: Bool -> Void) {
		animate(duration: duration, usingSpringWithDamping: damping, initialSpringVelocity: 0, options: options, delay: delay, animations: animations, completion: completion)
	}

	public class func animate(#duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, initialSpringVelocity: CGFloat, animations: () -> Void) {
		animate(duration: duration, usingSpringWithDamping: damping, initialSpringVelocity: initialSpringVelocity, options: nil, delay: 0, animations: animations)
	}

	public class func animate(#duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, initialSpringVelocity: CGFloat, animations: () -> Void, completion: Bool -> Void) {
		animate(duration: duration, usingSpringWithDamping: damping, initialSpringVelocity: initialSpringVelocity, options: nil, delay: 0, animations: animations, completion: completion)
	}

	public class func animate(#duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: () -> Void) {
		animate(duration: duration, usingSpringWithDamping: damping, initialSpringVelocity: initialSpringVelocity, options: options, delay: 0, animations: animations)
	}

	public class func animate(#duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: () -> Void, completion: Bool -> Void) {
		animate(duration: duration, usingSpringWithDamping: damping, initialSpringVelocity: initialSpringVelocity, options: options, delay: 0, animations: animations, completion: completion)
	}

	public class func animate(#duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, delay: NSTimeInterval, animations: () -> Void) {
		animateWithDuration(duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: nil)
	}

	public class func animate(#duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, delay: NSTimeInterval, animations: () -> Void, completion: Bool -> Void) {
		animateWithDuration(duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
	}


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

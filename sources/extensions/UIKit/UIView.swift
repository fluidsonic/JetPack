import UIKit


public extension UIView {

	public class func animateWithDuration(duration: NSTimeInterval, initialSpringVelocity velocity: CGFloat, animations: () -> Void) {
		animateWithDuration(duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity, options: nil, animations: animations, completion: nil)
	}

	public class func animateWithDuration(duration: NSTimeInterval, initialSpringVelocity velocity: CGFloat, options: UIViewAnimationOptions, animations: () -> Void) {
		animateWithDuration(duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity, options: options, animations: animations, completion: nil)
	}

	public class func animateWithDuration(duration: NSTimeInterval, initialSpringVelocity velocity: CGFloat, options: UIViewAnimationOptions, animations: () -> Void, completion: Bool -> Void) {
		animateWithDuration(duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity, options: options, animations: animations, completion: completion)
	}

	public class func animateWithDuration(duration: NSTimeInterval, usingSpringWithDamping damping: CGFloat, animations: () -> Void) {
		animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: 0, options: nil, animations: animations, completion: nil)
	}

	public class func animateWithDuration(duration: NSTimeInterval, delay: NSTimeInterval = 0, options: UIViewAnimationOptions = nil, animations: () -> Void) {
		animateWithDuration(duration, delay: delay, options: options, animations: animations, completion: nil)
	}

	public class func animateWithDuration(duration: NSTimeInterval, delay: NSTimeInterval = 0, options: UIViewAnimationOptions = nil, animations: () -> Void, completion: Bool -> Void) {
		animateWithDuration(duration, delay: delay, options: options, animations: animations, completion: completion)
	}

	public class func animateWithDuration(duration: NSTimeInterval, delay: NSTimeInterval = 0, usingSpringWithDamping damping: CGFloat, initialSpringVelocity velocity: CGFloat = 0, options: UIViewAnimationOptions = nil, animations: () -> Void) {
		animateWithDuration(duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: options, animations: animations, completion: nil)
	}

	public class func animateWithDuration(duration: NSTimeInterval, delay: NSTimeInterval = 0, usingSpringWithDamping damping: CGFloat, initialSpringVelocity velocity: CGFloat = 0, options: UIViewAnimationOptions = nil, animations: () -> Void, completion: Bool -> Void) {
		animateWithDuration(duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: options, animations: animations, completion: completion)
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

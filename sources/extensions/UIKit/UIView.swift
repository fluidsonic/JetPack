import UIKit


public extension UIView {

	public class func animateWithDuration(duration: NSTimeInterval, initialSpringVelocity velocity: CGFloat, animations: () -> Void) {
		animateWithDuration(duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity, options: nil, animations: animations, completion: nil)
	}

	public class func animateWithDuration(duration: NSTimeInterval, initialSpringVelocity velocity: CGFloat, options: UIViewAnimationOptions, animations: () -> Void) {
		animateWithDuration(duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity, options: options, animations: animations, completion: nil)
	}

	public class func animateWithDuration(duration: NSTimeInterval, initialSpringVelocity velocity: CGFloat, options: UIViewAnimationOptions, animations: () -> Void, completion: ((Bool) -> Void)?) {
		animateWithDuration(duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity, options: options, animations: animations, completion: completion)
	}

	public func heightThatFits() -> CGFloat {
		return sizeThatFits(CGSize.maxSize).height
	}

	public func heightThatFitsWidth(width: CGFloat) -> CGFloat {
		return sizeThatFits(CGSize(width: width, height: CGFloat.max)).height
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

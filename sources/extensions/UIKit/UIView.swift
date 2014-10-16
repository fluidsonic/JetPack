import UIKit


extension UIView {

	class func animateWithDuration(duration: NSTimeInterval, initialSpringVelocity velocity: CGFloat, animations: () -> Void) {
		animateWithDuration(duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity, options: nil, animations: animations, completion: nil)
	}

	class func animateWithDuration(duration: NSTimeInterval, initialSpringVelocity velocity: CGFloat, options: UIViewAnimationOptions, animations: () -> Void) {
		animateWithDuration(duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity, options: options, animations: animations, completion: nil)
	}

	class func animateWithDuration(duration: NSTimeInterval, initialSpringVelocity velocity: CGFloat, options: UIViewAnimationOptions, animations: () -> Void, completion: ((Bool) -> Void)?) {
		animateWithDuration(duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity, options: options, animations: animations, completion: completion)
	}

	func heightThatFits() -> CGFloat {
		return sizeThatFits(CGSize.maxSize).height
	}

	func heightThatFitsWidth(width: CGFloat) -> CGFloat {
		return sizeThatFits(CGSize(width: width, height: CGFloat.max)).height
	}

	func sizeThatFits() -> CGSize {
		return sizeThatFits(CGSize.maxSize)
	}

	func sizeThatFitsHeight(height: CGFloat) -> CGSize {
		return sizeThatFits(CGSize(width: CGFloat.max, height: height))
	}

	func sizeThatFitsWidth(width: CGFloat) -> CGSize {
		return sizeThatFits(CGSize(width: width, height: CGFloat.max))
	}

	func widthThatFits() -> CGFloat {
		return sizeThatFits(CGSize.maxSize).width
	}

	func widthThatFitsHeight(height: CGFloat) -> CGFloat {
		return sizeThatFits(CGSize(width: CGFloat.max, height: height)).width
	}
}

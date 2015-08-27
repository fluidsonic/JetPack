import UIKit


public extension UIViewController {

	public func dismissViewController(animated: Bool = true) {
		dismissViewControllerAnimated(animated, completion: nil)
	}


	public func presentViewController(viewControllerToPresent: UIViewController, animated: Bool = true) {
		presentViewController(viewControllerToPresent, animated: animated, completion: nil)
	}
}

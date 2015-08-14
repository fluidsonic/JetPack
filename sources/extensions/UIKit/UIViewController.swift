import UIKit


public extension UIViewController {

	public func dismissViewControllerAnimated(_ animated: Bool = true) {
		dismissViewControllerAnimated(animated, completion: nil)
	}


	public func presentViewController(viewControllerToPresent: UIViewController, animated: Bool) {
		presentViewController(viewControllerToPresent, animated: animated, completion: nil)
	}
}

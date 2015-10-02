import UIKit


public extension UIViewController {

	public func dismissViewController(completion: Closure? = nil) {
		dismissViewControllerAnimated(true, completion: completion)
	}


	public func dismissViewControllerAnimated(animated: Bool) {
		dismissViewControllerAnimated(animated, completion: nil)
	}


	public func presentAlertWithMessage(message: String, okayHandler: Closure? = nil) {
		presentAlertWithTitle("", message: message, okayHandler: okayHandler)
	}


	public func presentAlertWithTitle(title: String, message: String, okayHandler: Closure? = nil) {
		let alertController = UIAlertController(alertWithTitle: title, message: message)
		alertController.addOkayAction(okayHandler)

		presentViewController(alertController)
	}


	public func presentViewController(viewControllerToPresent: UIViewController, animated: Bool) {
		presentViewController(viewControllerToPresent, animated: animated, completion: nil)
	}


	public func presentViewController(viewControllerToPresent: UIViewController, completion: Closure? = nil) {
		presentViewController(viewControllerToPresent, animated: true, completion: completion)
	}
}

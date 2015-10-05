import UIKit


public extension UIViewController {

	@nonobjc
	public func dismissViewController(completion: Closure? = nil) {
		dismissViewControllerAnimated(true, completion: completion)
	}


	@nonobjc
	public func dismissViewControllerAnimated(animated: Bool) {
		dismissViewControllerAnimated(animated, completion: nil)
	}


	@nonobjc
	public func presentAlertWithMessage(message: String, okayHandler: Closure? = nil) {
		presentAlertWithTitle("", message: message, okayHandler: okayHandler)
	}


	@nonobjc
	public func presentAlertWithTitle(title: String, message: String, okayHandler: Closure? = nil) {
		let alertController = UIAlertController(alertWithTitle: title, message: message)
		alertController.addOkayAction(okayHandler)

		presentViewController(alertController)
	}


	@nonobjc
	public func presentViewController(viewControllerToPresent: UIViewController, animated: Bool) {
		presentViewController(viewControllerToPresent, animated: animated, completion: nil)
	}


	@nonobjc
	public func presentViewController(viewControllerToPresent: UIViewController, completion: Closure? = nil) {
		presentViewController(viewControllerToPresent, animated: true, completion: completion)
	}
}

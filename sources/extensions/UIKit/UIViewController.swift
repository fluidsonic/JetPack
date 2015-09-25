public extension UIViewController {

	public func dismissViewController(animated: Bool = true) {
		dismissViewControllerAnimated(animated, completion: nil)
	}


	public func presentAlertWithMessage(message: String) {
		presentAlertWithTitle("", message: message)
	}


	public func presentAlertWithTitle(title: String, message: String) {
		let alertController = UIAlertController(alertWithTitle: title, message: message)
		alertController.addOkayAction()

		presentViewController(alertController)
	}


	public func presentViewController(viewControllerToPresent: UIViewController, animated: Bool = true) {
		presentViewController(viewControllerToPresent, animated: animated, completion: nil)
	}
}

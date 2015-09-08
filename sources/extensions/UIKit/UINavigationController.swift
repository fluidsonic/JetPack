import UIKit


public extension UINavigationController {

	public func pushViewController(viewController: UIViewController) {
		pushViewController(viewController, animated: true)
	}
}

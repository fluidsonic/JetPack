import UIKit


public extension UINavigationController {

	@nonobjc
	public func pushViewController(viewController: UIViewController) {
		pushViewController(viewController, animated: true)
	}
}

import UIKit


public extension UINavigationController {

	public override func computeInnerDecorationInsetsForChildViewController(childViewController: UIViewController) -> UIEdgeInsets {
		var insets = innerDecorationInsets
		insets.bottom += childViewController.bottomLayoutGuide.length - bottomLayoutGuide.length
		insets.top += childViewController.topLayoutGuide.length - topLayoutGuide.length

		return insets
	}


	public override func computeOuterDecorationInsetsForChildViewController(childViewController: UIViewController) -> UIEdgeInsets {
		var insets = outerDecorationInsets
		insets.bottom += childViewController.bottomLayoutGuide.length - bottomLayoutGuide.length
		insets.top += childViewController.topLayoutGuide.length - topLayoutGuide.length

		return insets
	}


	@nonobjc
	public func pushViewController(viewController: UIViewController) {
		pushViewController(viewController, animated: true)
	}
}

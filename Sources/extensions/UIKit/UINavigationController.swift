import UIKit


public extension UINavigationController {

	public override func computeInnerDecorationInsetsForChildViewController(childViewController: UIViewController) -> UIEdgeInsets {
		return addTopAndBottomBarsToDecorationInsets(innerDecorationInsets)
	}


	public override func computeOuterDecorationInsetsForChildViewController(childViewController: UIViewController) -> UIEdgeInsets {
		return addTopAndBottomBarsToDecorationInsets(outerDecorationInsets)
	}


	@nonobjc
	private func addTopAndBottomBarsToDecorationInsets(var decorationInsets: UIEdgeInsets) -> UIEdgeInsets {
		if !toolbarHidden, let toolbar = toolbar where !toolbar.opaque {
			decorationInsets.bottom = max(view.bounds.height - toolbar.frame.top, decorationInsets.bottom)
		}
		if !navigationBarHidden && !navigationBar.opaque {
			decorationInsets.top = max(navigationBar.frame.bottom, decorationInsets.bottom)
		}

		return decorationInsets
	}


	@nonobjc
	public func pushViewController(viewController: UIViewController) {
		pushViewController(viewController, animated: true)
	}
}

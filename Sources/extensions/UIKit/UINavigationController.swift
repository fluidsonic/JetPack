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
			decorationInsets.top = max(navigationBar.frame.bottom, decorationInsets.top)
		}

		return decorationInsets
	}


	@nonobjc
	public func pushViewController(viewController: UIViewController) {
		pushViewController(viewController, animated: true)
	}


	@nonobjc
	internal static func UINavigationController_setUp() {
		swizzleInType(self, fromSelector: "setNavigationBarHidden:", toSelector: "JetPack_setNavigationBarHidden:")
		swizzleInType(self, fromSelector: "setNavigationBarHidden:animated:", toSelector: "JetPack_setNavigationBarHidden:animated:")
	}


	@objc(JetPack_setNavigationBarHidden:)
	private func swizzled_setNavigationBarHidden(navigationBarHidden: Bool) {
		setNavigationBarHidden(navigationBarHidden, animated: false)
	}


	@objc(JetPack_setNavigationBarHidden:animated:)
	private func swizzled_setNavigationBarHidden(navigationBarHidden: Bool, animated: Bool) {
		guard navigationBarHidden != self.navigationBarHidden else {
			return
		}

		swizzled_setNavigationBarHidden(navigationBarHidden, animated: animated)

		topViewController?.invalidateDecorationInsetsWithAnimation(animated ? Animation(duration: NSTimeInterval(UINavigationControllerHideShowBarDuration), timing: .EaseInEaseOut) : nil)
	}
}

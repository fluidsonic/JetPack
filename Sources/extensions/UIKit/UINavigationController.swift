import UIKit


public extension UINavigationController {

	private struct AssociatedKeys {
		private static var lastKnownNavigationBarBottom = UInt8()
	}


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
	internal func checkNavigationBarFrame() {
		// UINavigationControllers update their navigation bar and force-layout their child view controllers at weird times (e.g. when they were added to a window)
		// which causes decoration insets not being updated due to status bar height changes. So for now we check for changes here.

		let navigationBarBottom = navigationBar.frame.bottom
		if navigationBarBottom != lastKnownNavigationBarBottom {
			lastKnownNavigationBarBottom = navigationBarBottom

			topViewController?.invalidateDecorationInsetsWithAnimation(nil)
		}
	}


	@nonobjc
	private var lastKnownNavigationBarBottom: CGFloat {
		get { return objc_getAssociatedObject(self, &AssociatedKeys.lastKnownNavigationBarBottom) as? CGFloat ?? 0 }
		set { objc_setAssociatedObject(self, &AssociatedKeys.lastKnownNavigationBarBottom, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}


	@nonobjc
	public func pushViewController(viewController: UIViewController) {
		pushViewController(viewController, animated: true)
	}


	@nonobjc
	internal static func UINavigationController_setUp() {
		swizzleMethodInType(self, fromSelector: "setNavigationBarHidden:", toSelector: "JetPack_setNavigationBarHidden:")
		swizzleMethodInType(self, fromSelector: "setNavigationBarHidden:animated:", toSelector: "JetPack_setNavigationBarHidden:animated:")
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

		lastKnownNavigationBarBottom = navigationBar.frame.bottom

		topViewController?.invalidateDecorationInsetsWithAnimation(animated ? Animation(duration: NSTimeInterval(UINavigationControllerHideShowBarDuration), timing: .EaseInEaseOut) : nil)
	}
}

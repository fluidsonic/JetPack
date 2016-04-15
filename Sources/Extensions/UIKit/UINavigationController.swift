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
	private func addTopAndBottomBarsToDecorationInsets(decorationInsets: UIEdgeInsets) -> UIEdgeInsets {
		var adjustedDecorationInsets = decorationInsets

		if !toolbarHidden, let toolbar = toolbar {
			let toolbarHeight = view.bounds.height - toolbar.frame.top
			if toolbar.translucent {
				adjustedDecorationInsets.bottom = max(toolbarHeight, adjustedDecorationInsets.bottom)
			}
			else {
				adjustedDecorationInsets.bottom = max(adjustedDecorationInsets.bottom - toolbarHeight, 0)
			}
		}

		if !navigationBarHidden {
			let navigationBarHeight = navigationBar.frame.bottom
			if navigationBar.translucent {
				adjustedDecorationInsets.top = max(navigationBarHeight, adjustedDecorationInsets.top)
			}
			else {
				adjustedDecorationInsets.top = max(adjustedDecorationInsets.top - navigationBarHeight, 0)
			}
		}

		return adjustedDecorationInsets
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
	public func popViewController() {
		popViewControllerAnimated(true)
	}


	@nonobjc
	public func pushViewController(viewController: UIViewController) {
		pushViewController(viewController, animated: true)
	}


	@objc(JetPack_setNavigationBarHidden:)
	private dynamic func swizzled_setNavigationBarHidden(navigationBarHidden: Bool) {
		setNavigationBarHidden(navigationBarHidden, animated: false)
	}


	@objc(JetPack_setNavigationBarHidden:animated:)
	private dynamic func swizzled_setNavigationBarHidden(navigationBarHidden: Bool, animated: Bool) {
		guard navigationBarHidden != self.navigationBarHidden else {
			return
		}

		swizzled_setNavigationBarHidden(navigationBarHidden, animated: animated)

		lastKnownNavigationBarBottom = navigationBar.frame.bottom

		topViewController?.invalidateDecorationInsetsWithAnimation(animated ? Animation(duration: NSTimeInterval(UINavigationControllerHideShowBarDuration), timing: .EaseInEaseOut) : nil)
	}


	@objc(JetPack_willTransitionToTraitCollection:withTransitionCoordinator:)
	private dynamic func swizzled_willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
		swizzled_willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)

		coordinator.animateAlongsideTransition { _ in
			self.checkNavigationBarFrame()
		}
	}


	@nonobjc
	internal static func UINavigationController_setUp() {
		swizzleMethodInType(self, fromSelector: Selector("setNavigationBarHidden:"),                                      toSelector: #selector(swizzled_setNavigationBarHidden(_:)))
		swizzleMethodInType(self, fromSelector: #selector(setNavigationBarHidden(_:animated:)),                           toSelector: #selector(swizzled_setNavigationBarHidden(_:animated:)))
		swizzleMethodInType(self, fromSelector: #selector(willTransitionToTraitCollection(_:withTransitionCoordinator:)), toSelector: #selector(swizzled_willTransitionToTraitCollection(_:withTransitionCoordinator:)))
	}
}

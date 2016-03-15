import UIKit


public extension UITabBarController {

	private struct AssociatedKeys {
		private static var lastKnownTabBarTop = UInt8()
	}
	


	public override func computeInnerDecorationInsetsForChildViewController(childViewController: UIViewController) -> UIEdgeInsets {
		return addTabBarToDecorationInsets(innerDecorationInsets)
	}


	public override func computeOuterDecorationInsetsForChildViewController(childViewController: UIViewController) -> UIEdgeInsets {
		return addTabBarToDecorationInsets(outerDecorationInsets)
	}


	@nonobjc
	private func addTabBarToDecorationInsets(var decorationInsets: UIEdgeInsets) -> UIEdgeInsets {
		if !tabBar.hidden && tabBar.translucent {
			decorationInsets.bottom = max(view.bounds.height - tabBar.frame.top, decorationInsets.bottom)
		}

		return decorationInsets
	}


	@nonobjc
	internal func checkTabBarFrame() {
		let tabBarTop = tabBar.frame.top
		if tabBarTop != lastKnownTabBarTop {
			lastKnownTabBarTop = tabBarTop

			selectedViewController?.invalidateDecorationInsetsWithAnimation(nil)
		}
	}


	@nonobjc
	private var lastKnownTabBarTop: CGFloat {
		get { return objc_getAssociatedObject(self, &AssociatedKeys.lastKnownTabBarTop) as? CGFloat ?? 0 }
		set { objc_setAssociatedObject(self, &AssociatedKeys.lastKnownTabBarTop, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}


	@nonobjc
	internal static func UITabBarController_setUp() {
		swizzleMethodInType(self, fromSelector: "willTransitionToTraitCollection:withTransitionCoordinator:", toSelector: "JetPack_willTransitionToTraitCollection:withTransitionCoordinator:")
	}


	@objc(JetPack_willTransitionToTraitCollection:withTransitionCoordinator:)
	private dynamic func swizzled_willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
		swizzled_willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)

		coordinator.animateAlongsideTransition { _ in
			self.checkTabBarFrame()
		}
	}
}
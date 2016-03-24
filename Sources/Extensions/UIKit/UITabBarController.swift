import UIKit


public extension UITabBarController {

	private struct AssociatedKeys {
		private static var lastKnownTabBarTop = UInt8()
	}
	


	public override func computeInnerDecorationInsetsForChildViewController(childViewController: UIViewController) -> UIEdgeInsets {
		return addTabBarToDecorationInsets(innerDecorationInsets, forChildViewController: childViewController)
	}


	public override func computeOuterDecorationInsetsForChildViewController(childViewController: UIViewController) -> UIEdgeInsets {
		return addTabBarToDecorationInsets(outerDecorationInsets, forChildViewController: childViewController)
	}


	@nonobjc
	private func addTabBarToDecorationInsets(decorationInsets: UIEdgeInsets, forChildViewController childViewController: UIViewController) -> UIEdgeInsets {
		guard tabBarAffectsDecorationInsetsForChildViewController(childViewController) else {
			return decorationInsets
		}

		var adjustedDecorationInsets = decorationInsets
		if !tabBar.hidden && tabBar.translucent {
			adjustedDecorationInsets.bottom = max(view.bounds.height - tabBar.frame.top, adjustedDecorationInsets.bottom)
		}

		return adjustedDecorationInsets
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
	private func tabBarAffectsDecorationInsetsForChildViewController(childViewController: UIViewController) -> Bool {
		guard !tabBar.hidden && tabBar.translucent else {
			return false
		}
		guard let navigationController = childViewController as? UINavigationController else {
			return true
		}

		for viewController in navigationController.viewControllers {
			guard !viewController.hidesBottomBarWhenPushed else {
				return false
			}
		}

		return true
	}


	@nonobjc
	internal static func UITabBarController_setUp() {
		swizzleMethodInType(self, fromSelector: #selector(willTransitionToTraitCollection(_:withTransitionCoordinator:)), toSelector: #selector(swizzled_willTransitionToTraitCollection(_:withTransitionCoordinator:)))
	}


	@objc(JetPack_willTransitionToTraitCollection:withTransitionCoordinator:)
	private dynamic func swizzled_willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
		swizzled_willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)

		coordinator.animateAlongsideTransition { _ in
			self.checkTabBarFrame()
		}
	}
}

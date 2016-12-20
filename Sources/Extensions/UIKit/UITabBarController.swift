import UIKit


extension UITabBarController {

	fileprivate struct AssociatedKeys {
		fileprivate static var lastKnownTabBarTop = UInt8()
	}
	


	open override func computeInnerDecorationInsetsForChildViewController(_ childViewController: UIViewController) -> UIEdgeInsets {
		return addTabBarToDecorationInsets(innerDecorationInsets, forChildViewController: childViewController)
	}


	open override func computeOuterDecorationInsetsForChildViewController(_ childViewController: UIViewController) -> UIEdgeInsets {
		return addTabBarToDecorationInsets(outerDecorationInsets, forChildViewController: childViewController)
	}


	@nonobjc
	fileprivate func addTabBarToDecorationInsets(_ decorationInsets: UIEdgeInsets, forChildViewController childViewController: UIViewController) -> UIEdgeInsets {
		guard tabBarAffectsDecorationInsetsForChildViewController(childViewController) else {
			return decorationInsets
		}

		var adjustedDecorationInsets = decorationInsets
		if !tabBar.isHidden && tabBar.isTranslucent {
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
	fileprivate var lastKnownTabBarTop: CGFloat {
		get { return objc_getAssociatedObject(self, &AssociatedKeys.lastKnownTabBarTop) as? CGFloat ?? 0 }
		set { objc_setAssociatedObject(self, &AssociatedKeys.lastKnownTabBarTop, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}


	@nonobjc
	fileprivate func tabBarAffectsDecorationInsetsForChildViewController(_ childViewController: UIViewController) -> Bool {
		guard !tabBar.isHidden && tabBar.isTranslucent else {
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
		swizzleMethodInType(self, fromSelector: #selector(willTransition(to:with:)), toSelector: #selector(swizzled_willTransitionToTraitCollection(_:withTransitionCoordinator:)))
	}


	@objc(JetPack_willTransitionToTraitCollection:withTransitionCoordinator:)
	fileprivate dynamic func swizzled_willTransitionToTraitCollection(_ newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
		swizzled_willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)

		coordinator.animate(alongsideTransition: { _ in
			self.checkTabBarFrame()
		})
	}
}

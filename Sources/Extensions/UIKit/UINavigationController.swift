import UIKit


extension UINavigationController {

	private struct AssociatedKeys {
		fileprivate static var lastKnownNavigationBarBottom = UInt8()
	}



	open override func computeInnerDecorationInsetsForChildViewController(_ childViewController: UIViewController) -> UIEdgeInsets {
		return addTopAndBottomBarsToDecorationInsets(innerDecorationInsets)
	}


	open override func computeOuterDecorationInsetsForChildViewController(_ childViewController: UIViewController) -> UIEdgeInsets {
		return addTopAndBottomBarsToDecorationInsets(outerDecorationInsets)
	}


	@nonobjc
	fileprivate func addTopAndBottomBarsToDecorationInsets(_ decorationInsets: UIEdgeInsets) -> UIEdgeInsets {
		var adjustedDecorationInsets = decorationInsets

		if !isToolbarHidden, let toolbar = toolbar {
			let toolbarHeight = view.bounds.height - toolbar.frame.top
			if toolbar.isTranslucent {
				adjustedDecorationInsets.bottom = max(toolbarHeight, adjustedDecorationInsets.bottom)
			}
			else {
				adjustedDecorationInsets.bottom = max(adjustedDecorationInsets.bottom - toolbarHeight, 0)
			}
		}

		if !isNavigationBarHidden {
			let navigationBarHeight = navigationBar.frame.bottom
			if navigationBar.isTranslucent {
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
	fileprivate var lastKnownNavigationBarBottom: CGFloat {
		get { return objc_getAssociatedObject(self, &AssociatedKeys.lastKnownNavigationBarBottom) as? CGFloat ?? 0 }
		set { objc_setAssociatedObject(self, &AssociatedKeys.lastKnownNavigationBarBottom, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}


	@nonobjc
	public func popToRootViewController() {
		popToRootViewController(animated: true)
	}


	@nonobjc
	public func popViewController() {
		popViewController(animated: true)
	}


	@nonobjc
	public func pushViewController(_ viewController: UIViewController) {
		pushViewController(viewController, animated: true)
	}


	@objc(JetPack_setNavigationBarHidden:)
	fileprivate dynamic func swizzled_setNavigationBarHidden(_ navigationBarHidden: Bool) {
		setNavigationBarHidden(navigationBarHidden, animated: false)
	}


	@objc(JetPack_setNavigationBarHidden:animated:)
	fileprivate dynamic func swizzled_setNavigationBarHidden(_ navigationBarHidden: Bool, animated: Bool) {
		guard navigationBarHidden != self.isNavigationBarHidden else {
			return
		}

		swizzled_setNavigationBarHidden(navigationBarHidden, animated: animated)

		lastKnownNavigationBarBottom = navigationBar.frame.bottom

		topViewController?.invalidateDecorationInsetsWithAnimation(animated ? Animation(duration: TimeInterval(UINavigationControllerHideShowBarDuration), timing: .easeInEaseOut) : nil)
	}


	@objc(JetPack_willTransitionToTraitCollection:withTransitionCoordinator:)
	fileprivate dynamic func swizzled_willTransitionToTraitCollection(_ newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
		swizzled_willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)

		coordinator.animate(alongsideTransition: { _ in
			self.checkNavigationBarFrame()
		})
	}
}


@objc(_JetPack_Extensions_UIKit_UINavigationController_Initialization)
private class StaticInitialization: NSObject, StaticInitializable {

	static func staticInitialize() {
		swizzleMethod(in: UINavigationController.self, from: #selector(setter: UINavigationController.isNavigationBarHidden),       to: #selector(UINavigationController.swizzled_setNavigationBarHidden(_:)))
		swizzleMethod(in: UINavigationController.self, from: #selector(UINavigationController.setNavigationBarHidden(_:animated:)), to: #selector(UINavigationController.swizzled_setNavigationBarHidden(_:animated:)))
		swizzleMethod(in: UINavigationController.self, from: #selector(UINavigationController.willTransition(to:with:)),            to: #selector(UINavigationController.swizzled_willTransitionToTraitCollection(_:withTransitionCoordinator:)))
	}
}

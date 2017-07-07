import ObjectiveC
import UIKit


extension UIViewController {

	@objc(JetPack_childViewControllerForNavigationBarVisibility)
	open var childViewControllerForNavigationBarVisibility: UIViewController? {
		return nil
	}


	@objc(JetPack_preferredNavigationBarTintColor)
	open var preferredNavigationBarTintColor: UIColor? {
		return nil
	}


	@objc(JetPack_preferredNavigationBarVisibility)
	open var preferredNavigationBarVisibility: NavigationBar.Visibility {
		return .visible
	}


	@objc(JetPack_UI_viewWillAppear:)
	fileprivate dynamic func swizzled_viewWillAppear(_ animated: Bool) {
		swizzled_viewWillAppear(animated)

		updateNavigationBarStyle()
	}


	@nonobjc
	public func updateNavigationBarStyle(animation: Animation? = Animation()) {
		guard let navigationController = navigationController as? NavigationController else {
			return
		}

		navigationController.updateNavigationBarStyleForTopViewController(animation: animation)
	}
}


@objc(_JetPack_UI_UIViewController_Initialization)
private class StaticInitialization: NSObject, StaticInitializable {

	static func staticInitialize() {
		swizzleMethod(in: UIViewController.self, from: #selector(UIViewController.viewWillAppear(_:)), to: #selector(UIViewController.swizzled_viewWillAppear(_:)))
	}
}

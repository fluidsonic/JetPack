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
	private dynamic func swizzled_viewWillAppear(_ animated: Bool) {
		swizzled_viewWillAppear(animated)

		updateNavigationBarStyle()
	}


	@nonobjc
	static func UIViewController_UI_setUp() {
		swizzleMethod(in: self, from: #selector(viewWillAppear(_:)), to: #selector(swizzled_viewWillAppear(_:)))
	}


	@nonobjc
	public func updateNavigationBarStyle(animation: Animation? = Animation()) {
		guard let navigationController = navigationController as? NavigationController else {
			return
		}

		navigationController.updateNavigationBarStyleForTopViewController(animation: animation)
	}
}

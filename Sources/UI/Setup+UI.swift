import Foundation
import UIKit


public extension UIApplication {

	private static let setup = Setup()


	// TODO We should no longer rely on +initialize in extensions since it replaces UIKit's own implementation (if present)
	//      and can also collide with other frameworks & libraries implementing +initialize on the same class.
	@objc
	public final override class func initialize() {
		setup.noop()
	}
}



private struct Setup {

	fileprivate init() {
		Keyboard.setUp()

		CALayer.CALayer_setUp()

		UIApplication.UIApplication_setUp()
		UIView.UIView_setUp()

		UIBlurEffect.UIBlurEffect_setUp()
		UINavigationBar.UINavigationBar_setUp()
		UISearchBar.UISearchBar_setUp()
		UITableView.UITableView_setUp()
		UITableViewCell.UITableViewCell_setUp()
		UITextField.UITextField_setUp()
		UIWindow.UIWindow_setUp()

		UIViewController.UIViewController_setUp()
		UINavigationController.UINavigationController_setUp()
		UIPresentationController.UIPresentationController_setUp()
		UITabBarController.UITabBarController_setUp()

		UIViewController.UIViewController_UI_setUp()
	}


	func noop() {}
}

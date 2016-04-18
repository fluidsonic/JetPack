import UIKit


public /* non-final */ class NavigationController: UINavigationController {

	@nonobjc
	public init(navigationBarClass: NavigationBar.Type?, toolbarClass: UIToolbar.Type?) {
		super.init(navigationBarClass: navigationBarClass ?? NavigationBar.self, toolbarClass: toolbarClass)
	}


	public convenience init() {
		self.init(navigationBarClass: nil, toolbarClass: nil)
	}


	public override convenience init(rootViewController: UIViewController) {
		self.init(navigationBarClass: nil, toolbarClass: nil)

		pushViewController(rootViewController)
	}


	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	public override var childViewControllerForNavigationBarVisibility: UIViewController? {
		return topViewController?.childViewControllerForNavigationBarVisibility ?? topViewController
	}


	public override class func initialize() {
		guard self == NavigationController.self else {
			return
		}

		redirectMethodInType(self, fromSelector: #selector(UINavigationController.init(nibName:bundle:)), toSelector: #selector(UINavigationController.init(nibName:bundle:)), inType: UINavigationController.self)
	}


	@nonobjc
	public override var navigationBar: NavigationBar {
		return super.navigationBar as! NavigationBar
	}


	public override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
		return topViewController?.preferredInterfaceOrientationForPresentation() ?? ViewController.defaultPreferredInterfaceOrientationForPresentation()
	}


	public override func shouldAutorotate() -> Bool {
		return topViewController?.shouldAutorotate() ?? false
	}


	public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
		return topViewController?.supportedInterfaceOrientations() ?? ViewController.defaultSupportedInterfaceOrientationsForModalPresentationStyle(modalPresentationStyle)
	}


	internal final func updateNavigationBarVisibilityOfTopViewController(animation animation: Animation? = Animation()) {
		guard let topViewController = topViewController where navigationBar.topItem == topViewController.navigationItem else {
			return
		}

		let visibilityDeclaringChild = childViewControllerForNavigationBarVisibility ?? self
		let visibility = visibilityDeclaringChild.preferredNavigationBarVisibility

		setNavigationBarHidden(visibility == .Hidden, animated: animation != nil && appearState == .DidAppear)

		animation.runAlways {
			navigationBar.visibility = visibility
		}
	}
}

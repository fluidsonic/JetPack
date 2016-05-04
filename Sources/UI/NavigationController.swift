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


	public override func dismissViewController(animated animated: Bool = true, completion: Closure? = nil) {
		super.dismissViewControllerAnimated(animated, completion: completion)
	}


	@available(*, unavailable, renamed="dismissViewController")
	public final override func dismissViewControllerAnimated(flag: Bool, completion: Closure?) {
		presentedViewController?.dismissViewController(completion: completion)
	}


	public override class func initialize() {
		guard self == NavigationController.self else {
			return
		}

		redirectMethodInType(self, fromSelector: #selector(UINavigationController.init(nibName:bundle:)), toSelector: #selector(UINavigationController.init(nibName:bundle:)), inType: UINavigationController.self)

		copyMethodInType(object_getClass(self), fromSelector: #selector(overridesPreferredInterfaceOrientationForPresentation), toSelector: obfuscatedSelector("does", "Override", "Preferred", "Interface", "Orientation", "For", "Presentation"))
	}


	@nonobjc
	public override var navigationBar: NavigationBar {
		return super.navigationBar as! NavigationBar
	}


	@objc
	private static func overridesPreferredInterfaceOrientationForPresentation() -> Bool {
		// UIKit will behave differently if we override preferredInterfaceOrientationForPresentation.
		// Let's pretend we don't since we're just re-implementing the default behavior.
		return overridesSelector(#selector(preferredInterfaceOrientationForPresentation), ofBaseClass: NavigationController.self)
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


	internal final func updateNavigationBarStyleForTopViewController(animation animation: Animation? = Animation()) {
		guard let topViewController = topViewController else {
			return
		}

		let childForPreferredStyle = childViewControllerForNavigationBarVisibility ?? self
		let preferredTintColor = childForPreferredStyle.preferredNavigationBarTintColor
		let preferredVisibility = childForPreferredStyle.preferredNavigationBarVisibility

		setNavigationBarHidden(preferredVisibility == .Hidden, animated: animation != nil && appearState == .DidAppear)

		if navigationBar.topItem == topViewController.navigationItem {
			animation.runAlways {
				navigationBar.overridingTintColor = preferredTintColor
				navigationBar.visibility = preferredVisibility
			}
		}
	}
}

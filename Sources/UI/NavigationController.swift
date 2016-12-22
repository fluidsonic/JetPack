import UIKit


open /* non-final */ class NavigationController: UINavigationController {

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


	open override var childViewControllerForNavigationBarVisibility: UIViewController? {
		return topViewController?.childViewControllerForNavigationBarVisibility ?? topViewController
	}


	open override func dismissViewController(animated: Bool = true, completion: Closure? = nil) {
		super.dismiss(animated: animated, completion: completion)
	}


	@available(*, unavailable, renamed: "dismissViewController")
	public final override func dismiss(animated flag: Bool, completion: Closure?) {
		presentedViewController?.dismissViewController(completion: completion)
	}


	open override class func initialize() {
		guard self == NavigationController.self else {
			return
		}

		redirectMethod(in: self, from: #selector(UINavigationController.init(nibName:bundle:)), to: #selector(UINavigationController.init(nibName:bundle:)), in: UINavigationController.self)

		copyMethod(in: object_getClass(self), from: #selector(overridesPreferredInterfaceOrientationForPresentation), to: obfuscatedSelector("does", "Override", "Preferred", "Interface", "Orientation", "For", "Presentation"))
	}


	@nonobjc
	open override var navigationBar: NavigationBar {
		return super.navigationBar as! NavigationBar
	}


	@objc
	fileprivate static func overridesPreferredInterfaceOrientationForPresentation() -> Bool {
		// UIKit will behave differently if we override preferredInterfaceOrientationForPresentation.
		// Let's pretend we don't since we're just re-implementing the default behavior.
		return overridesSelector(#selector(getter: preferredInterfaceOrientationForPresentation), ofBaseClass: NavigationController.self)
	}


	open override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
		return topViewController?.preferredInterfaceOrientationForPresentation ?? ViewController.defaultPreferredInterfaceOrientationForPresentation()
	}


	open override var shouldAutorotate : Bool {
		return topViewController?.shouldAutorotate ?? false
	}


	open override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
		return topViewController?.supportedInterfaceOrientations ?? ViewController.defaultSupportedInterfaceOrientationsForModalPresentationStyle(modalPresentationStyle)
	}


	internal final func updateNavigationBarStyleForTopViewController(animation: Animation? = Animation()) {
		guard let topViewController = topViewController else {
			return
		}

		let navigationBar = self.navigationBar
		let childForPreferredStyle = childViewControllerForNavigationBarVisibility ?? self
		let preferredTintColor = childForPreferredStyle.preferredNavigationBarTintColor
		let preferredVisibility = childForPreferredStyle.preferredNavigationBarVisibility

		navigationBar.beginIgnoringItemChanges()
		setNavigationBarHidden(preferredVisibility == .hidden, animated: animation != nil && appearState == .didAppear)
		navigationBar.endIgnoringItemChanges()

		if navigationBar.topItem == topViewController.navigationItem {
			animation.runAlways {
				navigationBar.overridingTintColor = preferredTintColor
				navigationBar.visibility = preferredVisibility
			}
		}
	}
}

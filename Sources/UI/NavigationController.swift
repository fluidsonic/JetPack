import UIKit


open class NavigationController: UINavigationController {

	private var interactivePopGestureRecognizerDelegate: NavigationBarIndependentInteractivePopGestureRecognizerDelegate?
	private var overridden_isNavigationBarHidden: Bool?


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


	public var interactivePopGestureRequiresNavigationBar = true {
		didSet {
			guard interactivePopGestureRequiresNavigationBar != oldValue else {
				return
			}

			updateInteractivePopGestureRecognizerDelegate()
		}
	}


	open override var isNavigationBarHidden: Bool {
		get { return overridden_isNavigationBarHidden ?? super.isNavigationBarHidden }
		set { super.isNavigationBarHidden = newValue }
	}


	@nonobjc
	open override var navigationBar: NavigationBar {
		return super.navigationBar as! NavigationBar
	}


	func override<Result>(isNavigationBarHidden: Bool, block: () -> Result) -> Result {
		let	overridden_isNavigationBarHidden = self.overridden_isNavigationBarHidden
		self.overridden_isNavigationBarHidden = isNavigationBarHidden
		defer { self.overridden_isNavigationBarHidden = overridden_isNavigationBarHidden }

		return block()
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


	private func updateInteractivePopGestureRecognizerDelegate() {
		guard let interactivePopGestureRecognizer = interactivePopGestureRecognizer else {
			return
		}

		if interactivePopGestureRequiresNavigationBar {
			if let interactivePopGestureRecognizerDelegate = interactivePopGestureRecognizerDelegate {
				interactivePopGestureRecognizer.delegate = interactivePopGestureRecognizerDelegate.nextDelegate
				interactivePopGestureRecognizerDelegate.nextDelegate = nil

				self.interactivePopGestureRecognizerDelegate = nil
			}
		}
		else {
			if interactivePopGestureRecognizerDelegate == nil {
				interactivePopGestureRecognizerDelegate = .init(navigationController: self)
				interactivePopGestureRecognizerDelegate?.nextDelegate = interactivePopGestureRecognizer.delegate
				interactivePopGestureRecognizer.delegate = interactivePopGestureRecognizerDelegate
			}
		}
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


	open override func viewDidLoad() {
		super.viewDidLoad()

		updateInteractivePopGestureRecognizerDelegate()
	}
}



private class NavigationBarIndependentInteractivePopGestureRecognizerDelegate: NSObject, UIGestureRecognizerDelegate {

	private unowned let navigationController: NavigationController

	weak var nextDelegate: UIGestureRecognizerDelegate?


	init(navigationController: NavigationController) {
		self.navigationController = navigationController
	}


	@objc
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
		return nextDelegate?.gestureRecognizer?(gestureRecognizer, shouldReceive: press) ?? true
	}


	@objc
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		return navigationController.override(isNavigationBarHidden: false) {
			navigationController.navigationBar.override(hasBackButton: true) {
				nextDelegate?.gestureRecognizer?(gestureRecognizer, shouldReceive: touch) ?? true
			}
		}
	}


	@objc
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return nextDelegate?.gestureRecognizer?(gestureRecognizer, shouldRecognizeSimultaneouslyWith: otherGestureRecognizer) ?? false
	}


	@objc
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return nextDelegate?.gestureRecognizer?(gestureRecognizer, shouldBeRequiredToFailBy: otherGestureRecognizer) ?? false
	}


	@objc
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return nextDelegate?.gestureRecognizer?(gestureRecognizer, shouldRequireFailureOf: otherGestureRecognizer) ?? false
	}


	@objc
	func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		return nextDelegate?.gestureRecognizerShouldBegin?(gestureRecognizer) ?? true
	}
}


@objc(_JetPack_UI_NavigationController_Initialization)
private class StaticInitialization: NSObject, StaticInitializable {

	static func staticInitialize() {
		redirectMethod(in: NavigationController.self, from: #selector(UINavigationController.init(nibName:bundle:)), to: #selector(UINavigationController.init(nibName:bundle:)), in: UINavigationController.self)

		copyMethod(in: object_getClass(NavigationController.self)!, from: #selector(NavigationController.overridesPreferredInterfaceOrientationForPresentation), to: obfuscatedSelector("does", "Override", "Preferred", "Interface", "Orientation", "For", "Presentation"))
	}
}

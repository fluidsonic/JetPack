import ObjectiveC
import UIKit


public extension UIViewController {

	private struct AssociatedKeys {
		private static var appearState = UInt8()
		private static var presentingViewControllerForCurrentCoverageCallbacks = UInt8()
		private static var decorationInsetsAnimation = UInt8()
		private static var decorationInsetsAreValid = UInt8()
		private static var innerDecorationInsets = UInt8()
		private static var outerDecorationInsets = UInt8()
	}


	@nonobjc
	public private(set) var appearState: AppearState {
		get { return AppearState(id: objc_getAssociatedObject(self, &AssociatedKeys.appearState) as? Int ?? 0) }
		set { objc_setAssociatedObject(self, &AssociatedKeys.appearState, newValue.id, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}


	@objc(JetPack_applicationDidBecomeActive)
	public func applicationDidBecomeActive() {
		// override in subclasses
	}


	@nonobjc
	private static func applicationDidBecomeActive(notification: NSNotification) {
		traverseAllViewControllers() { viewController in
			viewController.applicationDidBecomeActive()
		}
	}


	@objc(JetPack_applicationWillResignActive)
	public func applicationWillResignActive() {
		// override in subclasses
	}


	@nonobjc
	private static func applicationWillResignActive(notification: NSNotification) {
		traverseAllViewControllers() { viewController in
			viewController.applicationWillResignActive()
		}
	}


	@objc(JetPack_computeInnerDecorationInsetsForChildViewController:)
	@warn_unused_result
	public func computeInnerDecorationInsetsForChildViewController(childViewController: UIViewController) -> UIEdgeInsets {
		return innerDecorationInsets
	}


	@objc(JetPack_computeOuterDecorationInsetsForChildViewController:)
	@warn_unused_result
	public func computeOuterDecorationInsetsForChildViewController(childViewController: UIViewController) -> UIEdgeInsets {
		return outerDecorationInsets
	}


	@nonobjc
	internal private(set) var decorationInsetsAnimation: Animation.Wrapper? {
		get { return objc_getAssociatedObject(self, &AssociatedKeys.decorationInsetsAnimation) as? Animation.Wrapper }
		set { objc_setAssociatedObject(self, &AssociatedKeys.decorationInsetsAnimation, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}


	@nonobjc
	private var decorationInsetsAreValid: Bool {
		get { return (objc_getAssociatedObject(self, &AssociatedKeys.decorationInsetsAreValid) as? NSNumber)?.boolValue ?? false }
		set { objc_setAssociatedObject(self, &AssociatedKeys.decorationInsetsAreValid, newValue ? true : nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}


	@objc(JetPack_decorationInsetsDidChangeWithAnimation:)
	public func decorationInsetsDidChangeWithAnimation(animationWrapper: Animation.Wrapper?) {
		for childViewController in childViewControllers {
			childViewController.invalidateDecorationInsetsWithAnimationWrapper(animationWrapper)
		}
	}


	@nonobjc
	public func dismissViewController(completion: Closure? = nil) {
		dismissViewControllerAnimated(true, completion: completion)
	}


	@nonobjc
	public func dismissViewControllerAnimated(animated: Bool) {
		dismissViewControllerAnimated(animated, completion: nil)
	}


	@nonobjc
	public private(set) var innerDecorationInsets: UIEdgeInsets {
		get { return (objc_getAssociatedObject(self, &AssociatedKeys.innerDecorationInsets) as? NSValue)?.UIEdgeInsetsValue() ?? .zero }
		set { objc_setAssociatedObject(self, &AssociatedKeys.innerDecorationInsets, newValue.isEmpty ? nil : NSValue(UIEdgeInsets: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}


	@nonobjc
	public func invalidateDecorationInsetsWithAnimation(animation: Animation?) {
		invalidateDecorationInsetsWithAnimationWrapper(animation?.wrap())
	}


	@nonobjc
	internal func invalidateDecorationInsetsWithAnimationWrapper(animationWrapper: Animation.Wrapper?) {
		if decorationInsetsAnimation == nil {
			decorationInsetsAnimation = animationWrapper
		}

		guard decorationInsetsAreValid else {
			return
		}

		decorationInsetsAreValid = false

		if window != nil {
			view.setNeedsLayout()
		}
	}


	@nonobjc
	private static func invalidateTopLevelDecorationInsetsWithAnimation(animation: Animation?) {
		for window in UIApplication.sharedApplication().windows {
			guard window.dynamicType == UIWindow.self || window is Window || !NSStringFromClass(window.dynamicType).hasPrefix("UI") else {
				// ignore system windows like the keyboard
				continue
			}

			let animationWrapper = animation?.wrap()

			var presentedViewController = window.rootViewController
			while let viewController = presentedViewController {
				viewController.invalidateDecorationInsetsWithAnimationWrapper(animationWrapper)
				presentedViewController = viewController.presentedViewController
			}
		}
	}


	@nonobjc
	public private(set) var outerDecorationInsets: UIEdgeInsets {
		get { return (objc_getAssociatedObject(self, &AssociatedKeys.outerDecorationInsets) as? NSValue)?.UIEdgeInsetsValue() ?? .zero }
		set { objc_setAssociatedObject(self, &AssociatedKeys.outerDecorationInsets, newValue.isEmpty ? nil : NSValue(UIEdgeInsets: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}


	@nonobjc
	public func presentAlertWithMessage(message: String, okayHandler: Closure? = nil) {
		presentAlertWithTitle("", message: message, okayHandler: okayHandler)
	}


	@nonobjc
	public func presentAlertWithTitle(title: String, message: String, okayHandler: Closure? = nil) {
		let alertController = UIAlertController(alertWithTitle: title, message: message)
		alertController.addOkayAction(okayHandler)

		presentViewController(alertController)
	}


	@nonobjc
	public func presentViewController(viewControllerToPresent: UIViewController, animated: Bool) {
		presentViewController(viewControllerToPresent, animated: animated, completion: nil)
	}


	@nonobjc
	public func presentViewController(viewControllerToPresent: UIViewController, completion: Closure? = nil) {
		presentViewController(viewControllerToPresent, animated: true, completion: completion)
	}


	@nonobjc
	private var presentingViewControllerForCurrentCoverageCallbacks: UIViewController? {
		get { return objc_getAssociatedObject(self, &AssociatedKeys.presentingViewControllerForCurrentCoverageCallbacks) as? UIViewController }
		set { objc_setAssociatedObject(self, &AssociatedKeys.presentingViewControllerForCurrentCoverageCallbacks, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}


	@nonobjc
	internal static func UIViewController_setUp() {
		swizzleMethodInType(self, fromSelector: "viewDidLayoutSubviews", toSelector: "JetPack_viewDidLayoutSubviews")
		swizzleMethodInType(self, fromSelector: "viewDidAppear:",        toSelector: "JetPack_viewDidAppear:")
		swizzleMethodInType(self, fromSelector: "viewDidDisappear:",     toSelector: "JetPack_viewDidDisappear:")
		swizzleMethodInType(self, fromSelector: "viewWillAppear:",       toSelector: "JetPack_viewWillAppear:")
		swizzleMethodInType(self, fromSelector: "viewWillDisappear:",    toSelector: "JetPack_viewWillDisappear:")

		subscribeToApplicationActiveNotifications()
		subscribeToKeyboardNotifications()
	}


	@nonobjc
	private static func subscribeToApplicationActiveNotifications() {
		let notificationCenter = NSNotificationCenter.defaultCenter()
		notificationCenter.addObserverForName(UIApplicationDidBecomeActiveNotification, object: nil, queue: nil, usingBlock: applicationDidBecomeActive)
		notificationCenter.addObserverForName(UIApplicationWillResignActiveNotification, object: nil, queue: nil, usingBlock: applicationWillResignActive)
	}


	@nonobjc
	private static func subscribeToKeyboardNotifications() {
		let _ = Keyboard.eventBus.subscribe { (_: Keyboard.Event.WillChangeFrame) in
			self.invalidateTopLevelDecorationInsetsWithAnimation(Keyboard.animation)
		}
	}


	@objc(JetPack_viewDidAppear:)
	private func swizzled_viewDidAppear(animated: Bool) {
		self.appearState = .DidAppear

		if isBeingPresented() && parentViewController == nil, let presentingViewController = self.presentingViewController where presentingViewController === presentingViewControllerForCurrentCoverageCallbacks {
			presentingViewController.traverseViewControllerSubtreeFromHereIncludingPresentedViewControllers(false) { viewController in
				guard viewController.appearState == .DidAppear else {
					return
				}

				viewController.viewWasCoveredByViewController(self, animated: animated)
			}
		}

		swizzled_viewDidAppear(animated)
	}


	@objc(JetPack_viewDidDisappear:)
	private func swizzled_viewDidDisappear(animated: Bool) {
		self.appearState = .DidDisappear

		if isBeingDismissed() && parentViewController == nil, let presentingViewController = presentingViewControllerForCurrentCoverageCallbacks {
			presentingViewController.traverseViewControllerSubtreeFromHereIncludingPresentedViewControllers(false) { viewController in
				guard viewController.appearState == .DidAppear else {
					return
				}

				viewController.viewWasUncoveredByViewController(self, animated: animated)
			}
		}

		presentingViewControllerForCurrentCoverageCallbacks = nil

		swizzled_viewDidDisappear(animated)
	}


	@objc(JetPack_viewDidLayoutSubviews)
	private func swizzled_viewDidLayoutSubviews() {
		updateDecorationInsets()

		swizzled_viewDidLayoutSubviews()
	}


	@objc(JetPack_viewWillAppear:)
	private func swizzled_viewWillAppear(animated: Bool) {
		self.appearState = .WillAppear

		if isBeingPresented() && parentViewController == nil, let presentingViewController = self.presentingViewController, presentationController = presentationController where !presentationController.shouldRemovePresentersView() {
			presentingViewControllerForCurrentCoverageCallbacks = presentingViewController

			presentingViewController.traverseViewControllerSubtreeFromHereIncludingPresentedViewControllers(false) { viewController in
				guard viewController.appearState == .DidAppear else {
					return
				}

				viewController.viewWillBeCoveredByViewController(self, animated: animated)
			}
		}

		// TODO invalidate decoration insets when moving to a window instead of when appearing
		decorationInsetsAnimation = nil
		invalidateDecorationInsetsWithAnimation(nil)

		swizzled_viewWillAppear(animated)
	}


	@objc(JetPack_viewWillDisappear:)
	private func swizzled_viewWillDisappear(animated: Bool) {
		self.appearState = .WillDisappear

		if isBeingDismissed() && parentViewController == nil, let presentingViewController = self.presentingViewController where presentingViewController === presentingViewControllerForCurrentCoverageCallbacks {
			presentingViewController.traverseViewControllerSubtreeFromHereIncludingPresentedViewControllers(false) { viewController in
				guard viewController.appearState == .DidAppear else {
					return
				}

				viewController.viewWillBeUncoveredByViewController(self, animated: animated)
			}
		}

		swizzled_viewWillDisappear(animated)
	}


	@nonobjc
	private static func traverseAllViewControllers(closure: UIViewController -> Void) {
		for window in UIApplication.sharedApplication().windows {
			window.rootViewController?.traverseViewControllerSubtreeFromHereIncludingPresentedViewControllers(true, closure: closure)
		}
	}


	@nonobjc
	private func traverseViewControllerSubtreeFromHereIncludingPresentedViewControllers(includesPresentedViewControllers: Bool, closure: UIViewController -> Void) {
		closure(self)

		for childViewController in childViewControllers {
			childViewController.traverseViewControllerSubtreeFromHereIncludingPresentedViewControllers(includesPresentedViewControllers, closure: closure)
		}

		if includesPresentedViewControllers {
			presentedViewController?.traverseViewControllerSubtreeFromHereIncludingPresentedViewControllers(true, closure: closure)
		}
	}


	@nonobjc
	internal func updateDecorationInsets() {
		guard let window = window where parentViewController == nil || !decorationInsetsAreValid else {
			return
		}

		let animation = decorationInsetsAnimation

		let innerDecorationInsets: UIEdgeInsets
		let outerDecorationInsets: UIEdgeInsets

		if let parentViewController = parentViewController {
			innerDecorationInsets = parentViewController.computeInnerDecorationInsetsForChildViewController(self)
			outerDecorationInsets = parentViewController.computeOuterDecorationInsetsForChildViewController(self)
		}
		else {
			var decorationInsets = UIEdgeInsets(top: topLayoutGuide.length, left: 0, bottom: bottomLayoutGuide.length, right: 0)

			let keyboardFrameInWindow = Keyboard.frameInView(window)
			if !keyboardFrameInWindow.isNull {
				let bottomDecorationInsetForKeyboard = max(window.bounds.height - keyboardFrameInWindow.top, 0)
				decorationInsets.bottom = max(bottomDecorationInsetForKeyboard, decorationInsets.bottom)
			}

			innerDecorationInsets = decorationInsets
			outerDecorationInsets = decorationInsets
		}

		let decorationInsetsChanged = innerDecorationInsets != self.innerDecorationInsets || outerDecorationInsets != self.outerDecorationInsets
		if decorationInsetsChanged {
			self.innerDecorationInsets = innerDecorationInsets
			self.outerDecorationInsets = outerDecorationInsets

			decorationInsetsDidChangeWithAnimation(animation)
		}

		decorationInsetsAnimation = nil
		decorationInsetsAreValid = true
	}


	@objc(JetPack_viewWasCoveredByViewController:animated:)
	public func viewWasCoveredByViewController(viewController: UIViewController, animated: Bool) {
		// override in subclasses
	}


	@objc(JetPack_viewWasUncoveredByViewController:animated:)
	public func viewWasUncoveredByViewController(viewController: UIViewController, animated: Bool) {
		// override in subclasses
	}


	@objc(JetPack_viewWillBeCoveredByViewController:animated:)
	public func viewWillBeCoveredByViewController(viewController: UIViewController, animated: Bool) {
		// override in subclasses
	}


	@objc(JetPack_viewWillBeUncoveredByViewController:animated:)
	public func viewWillBeUncoveredByViewController(viewController: UIViewController, animated: Bool) {
		// override in subclasses
	}


	@nonobjc
	public var window: UIWindow? {
		guard isViewLoaded() else {
			return nil
		}

		return view.window
	}


	public typealias AppearState = _UIViewControllerAppearState
}



// Temporarily moved out of UIViewController extension due to compiler bug.
// See https://travis-ci.org/fluidsonic/JetPack/jobs/93695509
public enum _UIViewControllerAppearState {
	case DidDisappear
	case WillAppear
	case DidAppear
	case WillDisappear


	private init(id: Int) {
		switch id {
		case 0: self = .DidDisappear
		case 1: self = .WillAppear
		case 2: self = .DidAppear
		case 3: self = .WillDisappear
		default: fatalError()
		}
	}


	private var id: Int {
		switch self {
		case .DidDisappear:  return 0
		case .WillAppear:    return 1
		case .DidAppear:     return 2
		case .WillDisappear: return 3
		}
	}


	public var isAppear: Bool {
		switch self {
		case .WillAppear, .DidAppear:       return true
		case .WillDisappear, .DidDisappear: return false
		}
	}


	public var isDisappear: Bool {
		switch self {
		case .WillAppear, .DidAppear:       return false
		case .WillDisappear, .DidDisappear: return true
		}
	}


	public var isTransition: Bool {
		switch self {
		case .WillAppear, .WillDisappear: return true
		case .DidAppear, .DidDisappear:   return false
		}
	}
}

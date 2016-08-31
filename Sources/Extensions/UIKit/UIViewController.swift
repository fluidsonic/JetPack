import ObjectiveC
import UIKit


public extension UIViewController {

	public typealias AppearState = _UIViewControllerAppearState
	public typealias ContainmentState = _UIViewControllerContainmentState


	private struct AssociatedKeys {
		private static var appearState = UInt8()
		private static var containmentState = UInt8()
		private static var presentingViewControllerForCurrentCoverageCallbacks = UInt8()
		private static var decorationInsetsAnimation = UInt8()
		private static var decorationInsetsAreValid = UInt8()
		private static var innerDecorationInsets = UInt8()
		private static var outerDecorationInsets = UInt8()
	}


	@nonobjc
	public private(set) var appearState: AppearState {
		get { return AppearState(id: objc_getAssociatedObject(self, &AssociatedKeys.appearState) as? Int ?? 0) }
		set {
			checkTransitionFromAppearState(self.appearState, toAppearState: newValue)
			objc_setAssociatedObject(self, &AssociatedKeys.appearState, newValue.id, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
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


	@nonobjc
	private func checkTransitionFromAppearState(fromAppearState: AppearState, toAppearState: AppearState) {
		func lifecycleMethodNameForAppearState(appearState: AppearState) -> String {
			switch appearState {
			case .DidAppear:     return "viewDidAppear()"
			case .DidDisappear:  return "viewDidDisappear()"
			case .WillAppear:    return "viewWillAppear()"
			case .WillDisappear: return "viewWillDisappear()"
			}
		}

		guard fromAppearState != toAppearState else {
			let toMethodName: String = lifecycleMethodNameForAppearState(toAppearState)
			let typeName: String = "\(self.dynamicType)"

			reportLifecycleProblem("\(typeName) (indirectly) called super.\(toMethodName) multiple times.", possibleCauses: [
				"\(typeName) or one of its superclasses called super.\(toMethodName) multiple times",
				"\(typeName) or one of its superclasses called the wrong function instead of super.\(toMethodName)",
				"it was called manually (it should never be called manually)",
				"the view controller containment implementation of \(nameForParentViewController()) or one if its parents is broken"
			])

			return
		}

		let expectedFromAppearStates: Set<AppearState>
		switch toAppearState {
		case .DidAppear:     expectedFromAppearStates = [.WillAppear]
		case .DidDisappear:  expectedFromAppearStates = [.WillDisappear]
		case .WillAppear:    expectedFromAppearStates = [.WillDisappear, .DidDisappear]
		case .WillDisappear: expectedFromAppearStates = [.WillAppear, .DidAppear]
		}

		if !expectedFromAppearStates.contains(fromAppearState) {
			let expectedFromMethodNames: String = expectedFromAppearStates.map({ lifecycleMethodNameForAppearState($0) }).joinWithSeparator(" or ")
			let expectedFromSuperCalls: String = "super." + expectedFromAppearStates.map({ lifecycleMethodNameForAppearState($0) }).joinWithSeparator("/")
			let toMethodName: String = lifecycleMethodNameForAppearState(toAppearState)
			let typeName: String = "\(self.dynamicType)"

			reportLifecycleProblem("\(typeName) (indirectly) called super.\(toMethodName) unexpectedly while the view controller is in \(fromAppearState) state. It method must only be called after \(expectedFromMethodNames).", possibleCauses: [
				"\(typeName) or one of its superclasses forgot to call \(expectedFromSuperCalls) earlier",
				"\(typeName) or one of its superclasses called the wrong function instead of super.\(toMethodName)",
				"it was called manually (it should never be called manually)",
				"the view controller containment implementation of \(nameForParentViewController()) or one if its parents is broken"
			])
		}
	}


	@objc(JetPack_childViewControllerForNavigationBarVisibility)
	public var childViewControllerForNavigationBarVisibility: UIViewController? {
		return nil
	}


	@nonobjc
	public private(set) var containmentState: ContainmentState {
		get { return ContainmentState(id: objc_getAssociatedObject(self, &AssociatedKeys.containmentState) as? Int ?? 0) }
		set { objc_setAssociatedObject(self, &AssociatedKeys.containmentState, newValue.id, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
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


	// reverse-engineered from preferredInterfaceOrientationForPresentation() @ iOS 9.3
	@nonobjc
	public static func defaultPreferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
		return UIApplication.sharedApplication().statusBarOrientation
	}


	// reverse-engineered from UIViewController.supportedInterfaceOrientations() @ iOS 9.3
	@nonobjc
	public static func defaultSupportedInterfaceOrientationsForModalPresentationStyle(modalPresentationStyle: UIModalPresentationStyle) -> UIInterfaceOrientationMask {
		if modalPresentationStyle == .Unknown16 {
			return .All
		}

		switch modalPresentationStyle {
		case .PageSheet, .FormSheet:
			return .All

		case .CurrentContext, .Custom, .FullScreen, .None, .OverCurrentContext, .OverFullScreen, .Popover:
			switch UIDevice.currentDevice().userInterfaceIdiom {
			case .Pad:
				return .All

			case .Phone:
				return .AllButUpsideDown

			case .CarPlay, .TV, .Unspecified:
				return .Portrait
			}
		}
	}


	@objc(JetPack_dismissViewControllerAnimated:completion:)
	public func dismissViewController(animated animated: Bool = true, completion: Closure? = nil) {
		if let presentedViewController = presentedViewController {
			log("Cannot dismiss view controller \(self) while it is presenting view controller \(presentedViewController).")
			return
		}
		guard presentingViewController != nil else {
			log("Cannot dismiss view controller \(self) which was not presented modally.")
			return
		}

		dismissViewControllerAnimated(animated, completion: completion)
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
			guard window.dynamicType == UIWindow.self || window is _NonSystemWindow || !NSStringFromClass(window.dynamicType).hasPrefix("UI") else {
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
	private func nameForParentViewController() -> String {
		guard let parentViewController = reliableParentViewController else {
			return "the parent view controller"
		}

		return String(parentViewController.dynamicType)
	}


	@nonobjc
	public private(set) var outerDecorationInsets: UIEdgeInsets {
		get { return (objc_getAssociatedObject(self, &AssociatedKeys.outerDecorationInsets) as? NSValue)?.UIEdgeInsetsValue() ?? .zero }
		set { objc_setAssociatedObject(self, &AssociatedKeys.outerDecorationInsets, newValue.isEmpty ? nil : NSValue(UIEdgeInsets: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}


	@objc(JetPack_preferredNavigationBarTintColor)
	public var preferredNavigationBarTintColor: UIColor? {
		return nil
	}


	@objc(JetPack_preferredNavigationBarVisibility)
	public var preferredNavigationBarVisibility: NavigationBar.Visibility {
		return .Visible
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
	private var reliableParentViewController: UIViewController? {
		if let parentViewController = parentViewController {
			return parentViewController
		}
		if let splitViewController = splitViewController where splitViewController.viewControllers.first === self {
			// parentViewController may be nil while split view controller's master view controller is displayed as overlay
			return splitViewController
		}

		return nil
	}


	@nonobjc
	private func reportLifecycleProblem(problem: String, possibleCauses: [String]) {
		guard shouldReportLifecycleProblems else {
			return
		}

		var message = "\nVIEW CONTROLLER LIFECYCLE BROKEN for \(self)\n\n"
		message += "Problem:\n\t"
		message += problem
		message += "\n\n"
		message += "Possible Causes:\n"
		message += "\t- "
		message += possibleCauses.joinWithSeparator("\n\t- ")
		message += "\n"

		print(message)
	}


	@nonobjc
	internal static func UIViewController_setUp() {
		swizzleMethodInType(self, fromSelector: #selector(didMoveToParentViewController(_:)),             toSelector: #selector(swizzled_didMoveToParentViewController(_:)))
		swizzleMethodInType(self, fromSelector: #selector(presentViewController(_:animated:completion:)), toSelector: #selector(swizzled_presentViewController(_:animated:completion:)))
		swizzleMethodInType(self, fromSelector: #selector(viewDidAppear(_:)),                             toSelector: #selector(swizzled_viewDidAppear(_:)))
		swizzleMethodInType(self, fromSelector: #selector(viewDidLayoutSubviews),                         toSelector: #selector(swizzled_viewDidLayoutSubviews))
		swizzleMethodInType(self, fromSelector: #selector(viewDidDisappear(_:)),                          toSelector: #selector(swizzled_viewDidDisappear(_:)))
		swizzleMethodInType(self, fromSelector: #selector(viewWillAppear(_:)),                            toSelector: #selector(swizzled_viewWillAppear(_:)))
		swizzleMethodInType(self, fromSelector: #selector(viewWillDisappear(_:)),                         toSelector: #selector(swizzled_viewWillDisappear(_:)))
		swizzleMethodInType(self, fromSelector: #selector(viewWillLayoutSubviews),                        toSelector: #selector(swizzled_viewWillLayoutSubviews))
		swizzleMethodInType(self, fromSelector: #selector(willMoveToParentViewController(_:)),            toSelector: #selector(swizzled_willMoveToParentViewController(_:)))

		subscribeToApplicationActiveNotifications()
		subscribeToKeyboardNotifications()
	}


	@nonobjc
	private var shouldReportLifecycleProblems: Bool {
		let typeName = NSStringFromClass(self.dynamicType)
		if typeName.hasPrefix("_") || typeName.hasPrefix("MFMail") || typeName.hasPrefix("MFMessage") || typeName.hasPrefix("PUUI") || typeName.hasPrefix("UICompatibility") || typeName.hasPrefix("UIInput") {
			// broken implementations in public and private UIKit view controllers
			return false
		}

		return true
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


	@objc(JetPack_didMoveToParentViewController:)
	private dynamic func swizzled_didMoveToParentViewController(parentViewController: UIViewController?) {
		let oldContainmentState = self.containmentState
		let newContainmentState: ContainmentState = parentViewController != nil ? .DidMoveToParent : .DidMoveFromParent

		if !newContainmentState.isValidSuccessorFor(oldContainmentState) {
			let typeName: String = "\(self.dynamicType)"

			var possibleCauses = [
				"\(typeName) or one of its superclasses called super.didMoveToParentViewController() multiple times",
				"\(typeName) or one of its superclasses called super.didMoveToParentViewController() from within it's .willMoveToParentViewController()",
				"the view controller containment implementation of \(nameForParentViewController()) or one if its parents is broken"
			]
			if parentViewController == nil {
				possibleCauses.append("it was already called implicitly by \(typeName).removeFromParentViewController() so you must not call it again")
			}

			reportLifecycleProblem(".didMoveToParentViewController(\(parentViewController != nil ? "non-nil" : "nil")) was called unexpectedly while view controller is in \(oldContainmentState) state.", possibleCauses: possibleCauses)
		}
		else if parentViewController !== self.parentViewController {
			reportLifecycleProblem(".didMoveToParentViewController() was called with parent \(parentViewController ?? "<nil>") but is currently moving to \(self.parentViewController ?? "<nil>").", possibleCauses: [ "the view controller containment implementation of \(nameForParentViewController()) or one if its parents is broken" ]
			)
		}
		else if appearState.isTransition {
			var possibleCauses = [ "the view controller containment implementation of \(nameForParentViewController()) or one if its parents is broken" ]

			if appearState == .WillAppear && newContainmentState == .DidMoveToParent {
				possibleCauses.append("this method was probably called from within the parent's .viewDidAppear() which does not imply that the child did complete it's transition yet")
			}

			reportLifecycleProblem(".didMoveToParentViewController() was called unexpectedly during an appearance transition. It must only be called while the view controller is in \(AppearState.DidDisappear) or \(AppearState.DidAppear) state.", possibleCauses: possibleCauses)
		}

		self.containmentState = newContainmentState

		swizzled_didMoveToParentViewController(parentViewController)
	}


	@objc(JetPack_presentViewController:animated:completion:)
	private dynamic func swizzled_presentViewController(viewControllerToPresent: UIViewController, animated: Bool, completion: Closure?) {
		swizzled_presentViewController(viewControllerToPresent, animated: animated, completion: completion)

		// workaround for UIKit bug, see http://stackoverflow.com/a/30787046/1183577
		CFRunLoopWakeUp(CFRunLoopGetCurrent())
	}


	@objc(JetPack_viewDidAppear:)
	private dynamic func swizzled_viewDidAppear(animated: Bool) {
		self.appearState = .DidAppear

		if containmentState == .WillMoveToParent {
			onMainQueueAfterDelay(1) {
				guard self.containmentState == .WillMoveToParent && self.appearState == .DidAppear else {
					return
				}

				self.reportLifecycleProblem(".didMoveToParentViewController(non-nil) was not called after .viewDidAppear() to complete an earlier .willMoveToParentViewController(non-nil).", possibleCauses: [
					"the view controller containment implementation of \(self.nameForParentViewController()) is likely broken"
				])
			}
		}

		if isBeingPresented() && reliableParentViewController == nil, let presentingViewController = self.presentingViewController where presentingViewController === presentingViewControllerForCurrentCoverageCallbacks {
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
	private dynamic func swizzled_viewDidDisappear(animated: Bool) {
		self.appearState = .DidDisappear

		if containmentState == .WillMoveFromParent {
			onMainQueueAfterDelay(1) {
				guard self.containmentState == .WillMoveFromParent && self.appearState == .DidDisappear else {
					return
				}

				self.reportLifecycleProblem(".didMoveToParentViewController(nil) was not called after .viewDidDisappear() to complete an earlier .willMoveToParentViewController(nil).", possibleCauses: [
					"the view controller containment implementation of \(self.nameForParentViewController()) is likely broken"
				])
			}
		}

		if isBeingDismissed() && reliableParentViewController == nil, let presentingViewController = presentingViewControllerForCurrentCoverageCallbacks {
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
	private dynamic func swizzled_viewDidLayoutSubviews() {
		swizzled_viewDidLayoutSubviews()

		if let navigationController = self as? UINavigationController {
			navigationController.checkNavigationBarFrame()
		}

		decorationInsetsAnimation = nil
	}


	@objc(JetPack_viewWillAppear:)
	private dynamic func swizzled_viewWillAppear(animated: Bool) {
		self.appearState = .WillAppear

		if tabBarController != nil, let navigationController = navigationController {
			navigationController.invalidateDecorationInsetsWithAnimation(nil)
		}

		if isBeingPresented() && reliableParentViewController == nil, let presentingViewController = self.presentingViewController, presentationController = presentationController where !presentationController.shouldRemovePresentersView() {
			presentingViewControllerForCurrentCoverageCallbacks = presentingViewController

			presentingViewController.traverseViewControllerSubtreeFromHereIncludingPresentedViewControllers(false) { viewController in
				guard viewController.appearState == .DidAppear else {
					return
				}

				viewController.viewWillBeCoveredByViewController(self, animated: animated)
			}
		}

		decorationInsetsAnimation = nil
		invalidateDecorationInsetsWithAnimation(nil)
		updateNavigationBarStyle()

		swizzled_viewWillAppear(animated)
	}


	@objc(JetPack_viewWillDisappear:)
	private dynamic func swizzled_viewWillDisappear(animated: Bool) {
		self.appearState = .WillDisappear

		if isBeingDismissed() && reliableParentViewController == nil, let presentingViewController = self.presentingViewController where presentingViewController === presentingViewControllerForCurrentCoverageCallbacks {
			presentingViewController.traverseViewControllerSubtreeFromHereIncludingPresentedViewControllers(false) { viewController in
				guard viewController.appearState == .DidAppear else {
					return
				}

				viewController.viewWillBeUncoveredByViewController(self, animated: animated)
			}
		}

		swizzled_viewWillDisappear(animated)
	}


	@objc(JetPack_viewWillLayoutSubviews)
	private dynamic func swizzled_viewWillLayoutSubviews() {
		updateDecorationInsets()

		swizzled_viewWillLayoutSubviews()
	}


	@objc(JetPack_willMoveToParentViewController:)
	private dynamic func swizzled_willMoveToParentViewController(parentViewController: UIViewController?) {
		let oldContainmentState = self.containmentState
		let newContainmentState: ContainmentState = parentViewController != nil ? .WillMoveToParent : .WillMoveFromParent

		if !newContainmentState.isValidSuccessorFor(oldContainmentState) {
			let typeName: String = "\(self.dynamicType)"

			var possibleCauses = [
				"\(typeName) or one of its superclasses called super.willMoveToParentViewController() multiple times",
				"\(typeName) or one of its superclasses called super.willMoveToParentViewController() from within it's .didMoveToParentViewController()",
				"the view controller containment implementation of \(nameForParentViewController()) or one if its parents is broken"
			]
			if parentViewController != nil {
				possibleCauses.append("it was already called implicitly by parent.addChildViewController(\(typeName)) so you must not call it again")
			}

			reportLifecycleProblem(".willMoveToParentViewController() was called unexpectedly while view controller is in \(oldContainmentState) state.", possibleCauses: possibleCauses)
		}
		else if appearState.isTransition {
			reportLifecycleProblem(".willMoveToParentViewController() was called unexpectedly during an appearance transition. It must only be called while the view controller is in \(AppearState.DidDisappear) or \(AppearState.DidAppear) state.", possibleCauses: [
				"the view controller containment implementation of \(nameForParentViewController()) or one if its parents is broken",
			])
		}

		self.containmentState = newContainmentState

		swizzled_willMoveToParentViewController(parentViewController)
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
		let parentViewController = reliableParentViewController

		guard let window = window where (parentViewController == nil || !decorationInsetsAreValid) else {
			return
		}
		guard !window.dynamicType.isPrivate else {
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

		decorationInsetsAreValid = true
	}


	@nonobjc
	public func updateNavigationBarStyle(animation animation: Animation? = Animation()) {
		guard let navigationController = navigationController as? NavigationController else {
			return
		}

		navigationController.updateNavigationBarStyleForTopViewController(animation: animation)
	}


	@objc(JetPack_viewDidMoveToWindow)
	public func viewDidMoveToWindow() {
		if window != nil && appearState.isAppear && !decorationInsetsAreValid {
			view.setNeedsLayout()
		}
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


extension UIViewController.AppearState: CustomStringConvertible {

	public var description: String {
		switch self {
		case .DidAppear:     return "DidAppear"
		case .DidDisappear:  return "DidDisappear"
		case .WillAppear:    return "WillAppear"
		case .WillDisappear: return "WillDisappear"
		}
	}
}



// Temporarily moved out of UIViewController extension due to compiler bug.
// See https://travis-ci.org/fluidsonic/JetPack/jobs/93695509
public enum _UIViewControllerContainmentState {
	case DidMoveFromParent
	case WillMoveToParent
	case DidMoveToParent
	case WillMoveFromParent


	private init(id: Int) {
		switch id {
		case 0: self = .DidMoveFromParent
		case 1: self = .WillMoveToParent
		case 2: self = .DidMoveToParent
		case 3: self = .WillMoveFromParent
		default: fatalError()
		}
	}


	private var id: Int {
		switch self {
		case .DidMoveFromParent:  return 0
		case .WillMoveToParent:   return 1
		case .DidMoveToParent:    return 2
		case .WillMoveFromParent: return 3
		}
	}


	public var isInOrMovingToParent: Bool {
		switch self {
		case .WillMoveToParent, .DidMoveToParent:     return true
		case .WillMoveFromParent, .DidMoveFromParent: return false
		}
	}


	public var isTransition: Bool {
		switch self {
		case .WillMoveToParent, .WillMoveFromParent: return true
		case .DidMoveToParent, .DidMoveFromParent:   return false
		}
	}


	private func isValidSuccessorFor(containmentState: _UIViewControllerContainmentState) -> Bool {
		switch self {
		case .DidMoveFromParent:  return (containmentState == .WillMoveFromParent)
		case .DidMoveToParent:    return (containmentState == .WillMoveToParent)
		case .WillMoveFromParent: return (containmentState == .WillMoveToParent   || containmentState == .DidMoveToParent)
		case .WillMoveToParent:   return (containmentState == .WillMoveFromParent || containmentState == .DidMoveFromParent)
		}
	}
}


extension UIViewController.ContainmentState: CustomStringConvertible {

	public var description: String {
		switch self {
		case .DidMoveToParent:    return "DidMoveToParent"
		case .DidMoveFromParent:  return "DidMoveFromParent"
		case .WillMoveToParent:   return "WillMoveToParent"
		case .WillMoveFromParent: return "WillMoveFromParent"
		}
	}
}

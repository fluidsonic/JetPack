import ObjectiveC
import UIKit


extension UIViewController {

	public typealias AppearState = _UIViewControllerAppearState
	public typealias ContainmentState = _UIViewControllerContainmentState


	fileprivate struct AssociatedKeys {

		fileprivate static var appearState = UInt8()
		fileprivate static var containmentState = UInt8()
		fileprivate static var decorationInsetsAnimation = UInt8()
		fileprivate static var decorationInsetsAreValid = UInt8()
		fileprivate static var innerDecorationInsets = UInt8()
		fileprivate static var isInLayout = UInt8()
		fileprivate static var needsAdditionalLayoutPass = UInt8()
		fileprivate static var outerDecorationInsets = UInt8()
		fileprivate static var presentingViewControllerForCurrentCoverageCallbacks = UInt8()
	}


	@nonobjc
	public fileprivate(set) var appearState: AppearState {
		get { return AppearState(id: objc_getAssociatedObject(self, &AssociatedKeys.appearState) as? Int ?? 0) }
		set {
			checkTransitionFromAppearState(self.appearState, toAppearState: newValue)
			objc_setAssociatedObject(self, &AssociatedKeys.appearState, newValue.id, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}


	@objc(JetPack_applicationDidBecomeActive)
	open func applicationDidBecomeActive() {
		// override in subclasses
	}


	@nonobjc
	private static func applicationDidBecomeActive(_ notification: Notification) {
		traverseAllViewControllers() { viewController in
			viewController.applicationDidBecomeActive()
		}
	}


	@objc(JetPack_applicationWillResignActive)
	open func applicationWillResignActive() {
		// override in subclasses
	}


	@nonobjc
	private static func applicationWillResignActive(_ notification: Notification) {
		traverseAllViewControllers() { viewController in
			viewController.applicationWillResignActive()
		}
	}


	@nonobjc
	fileprivate func checkTransitionFromAppearState(_ fromAppearState: AppearState, toAppearState: AppearState) {
		func lifecycleMethodNameForAppearState(_ appearState: AppearState) -> String {
			switch appearState {
			case .didAppear:     return "viewDidAppear()"
			case .didDisappear:  return "viewDidDisappear()"
			case .willAppear:    return "viewWillAppear()"
			case .willDisappear: return "viewWillDisappear()"
			}
		}

		guard fromAppearState != toAppearState else {
			let toMethodName: String = lifecycleMethodNameForAppearState(toAppearState)
			let typeName: String = "\(type(of: self))"

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
		case .didAppear:     expectedFromAppearStates = [.willAppear]
		case .didDisappear:  expectedFromAppearStates = [.willDisappear]
		case .willAppear:    expectedFromAppearStates = [.willDisappear, .didDisappear]
		case .willDisappear: expectedFromAppearStates = [.willAppear, .didAppear]
		}

		if !expectedFromAppearStates.contains(fromAppearState) {
			let expectedFromMethodNames: String = expectedFromAppearStates.map({ lifecycleMethodNameForAppearState($0) }).joined(separator: " or ")
			let expectedFromSuperCalls: String = "super." + expectedFromAppearStates.map({ lifecycleMethodNameForAppearState($0) }).joined(separator: "/")
			let toMethodName: String = lifecycleMethodNameForAppearState(toAppearState)
			let typeName: String = "\(type(of: self))"

			reportLifecycleProblem("\(typeName) (indirectly) called super.\(toMethodName) unexpectedly while the view controller is in \(fromAppearState) state. It method must only be called after \(expectedFromMethodNames).", possibleCauses: [
				"\(typeName) or one of its superclasses forgot to call \(expectedFromSuperCalls) earlier",
				"\(typeName) or one of its superclasses called the wrong function instead of super.\(toMethodName)",
				"it was called manually (it should never be called manually)",
				"the view controller containment implementation of \(nameForParentViewController()) or one if its parents is broken"
			])
		}
	}


	@nonobjc
	public fileprivate(set) var containmentState: ContainmentState {
		get { return ContainmentState(id: objc_getAssociatedObject(self, &AssociatedKeys.containmentState) as? Int ?? 0) }
		set { objc_setAssociatedObject(self, &AssociatedKeys.containmentState, newValue.id, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}


	@nonobjc
	private func computeDecorationInsets() -> (inner: UIEdgeInsets, outer: UIEdgeInsets)? {
		let parentViewController = reliableParentViewController

		guard let window = window, (parentViewController == nil || !decorationInsetsAreValid) else {
			return nil
		}
		guard !type(of: window).isPrivate else {
			return nil
		}

		let animation = decorationInsetsAnimation

		let innerDecorationInsets: UIEdgeInsets
		let outerDecorationInsets: UIEdgeInsets

		if let parentViewController = parentViewController {
			innerDecorationInsets = parentViewController.computeInnerDecorationInsetsForChildViewController(self)
			outerDecorationInsets = parentViewController.computeOuterDecorationInsetsForChildViewController(self)
		}
		else {
			var decorationInsets: UIEdgeInsets

			if #available(iOS 11.0, *) {
				decorationInsets = view.safeAreaInsets
			}
			else {
				decorationInsets = UIEdgeInsets(
					top:    topLayoutGuide.length,
					left:   0,
					bottom: bottomLayoutGuide.length,
					right:  0
				)
			}

			let keyboardFrameInWindow = Keyboard.frameInView(window)
			if !keyboardFrameInWindow.isNull {
				let bottomDecorationInsetForKeyboard = max(window.bounds.height - keyboardFrameInWindow.top, 0)
				decorationInsets.bottom = max(bottomDecorationInsetForKeyboard, decorationInsets.bottom)
			}

			innerDecorationInsets = decorationInsets
			outerDecorationInsets = decorationInsets
		}

		return (inner: innerDecorationInsets, outer: outerDecorationInsets)
	}


	@objc(JetPack_computeInnerDecorationInsetsForChildViewController:)
	open func computeInnerDecorationInsetsForChildViewController(_ childViewController: UIViewController) -> UIEdgeInsets {
		return innerDecorationInsets
	}


	@objc(JetPack_computeOuterDecorationInsetsForChildViewController:)
	open func computeOuterDecorationInsetsForChildViewController(_ childViewController: UIViewController) -> UIEdgeInsets {
		return outerDecorationInsets
	}


	@nonobjc
	internal fileprivate(set) var decorationInsetsAnimation: Animation.Wrapper? {
		get { return objc_getAssociatedObject(self, &AssociatedKeys.decorationInsetsAnimation) as? Animation.Wrapper }
		set { objc_setAssociatedObject(self, &AssociatedKeys.decorationInsetsAnimation, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}


	@nonobjc
	fileprivate var decorationInsetsAreValid: Bool {
		get { return (objc_getAssociatedObject(self, &AssociatedKeys.decorationInsetsAreValid) as? NSNumber)?.boolValue ?? false }
		set { objc_setAssociatedObject(self, &AssociatedKeys.decorationInsetsAreValid, newValue ? true : nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}


	@objc(JetPack_decorationInsetsDidChangeWithAnimation:)
	public func decorationInsetsDidChangeWithAnimation(_ animationWrapper: Animation.Wrapper?) {
		for childViewController in childViewControllers {
			childViewController.invalidateDecorationInsetsWithAnimationWrapper(animationWrapper)
		}
	}


	// reverse-engineered from preferredInterfaceOrientationForPresentation() @ iOS 9.3
	@nonobjc
	public static func defaultPreferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
		return UIApplication.shared.statusBarOrientation
	}


	// reverse-engineered from UIViewController.supportedInterfaceOrientations() @ iOS 9.3
	@nonobjc
	public static func defaultSupportedInterfaceOrientationsForModalPresentationStyle(_ modalPresentationStyle: UIModalPresentationStyle) -> UIInterfaceOrientationMask {
		if modalPresentationStyle == .Unknown16 {
			return .all
		}

		switch modalPresentationStyle {
		case .pageSheet, .formSheet:
			return .all

		case .blurOverFullScreen, .currentContext, .custom, .fullScreen, .none, .overCurrentContext, .overFullScreen, .popover:
			switch UIDevice.current.userInterfaceIdiom {
			case .pad:
				return .all

			case .phone:
				return .allButUpsideDown

			case .carPlay, .tv, .unspecified:
				return .portrait
			}
		}
	}


	@objc(JetPack_dismissViewControllerAnimated:completion:)
	public func dismissViewController(animated: Bool = true, completion: Closure? = nil) {
		if let presentedViewController = presentedViewController {
			log("Cannot dismiss view controller \(self) while it is presenting view controller \(presentedViewController).")
			return
		}
		guard presentingViewController != nil else {
			log("Cannot dismiss view controller \(self) which was not presented modally.")
			return
		}

		dismiss(animated: animated, completion: completion)
	}


	@objc(JetPack_innerDecorationInsets)
	open private(set) var innerDecorationInsets: UIEdgeInsets {
		get { return (objc_getAssociatedObject(self, &AssociatedKeys.innerDecorationInsets) as? NSValue)?.uiEdgeInsetsValue ?? .zero }
		set { objc_setAssociatedObject(self, &AssociatedKeys.innerDecorationInsets, newValue.isEmpty ? nil : NSValue(uiEdgeInsets: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}


	@nonobjc
	public func invalidateDecorationInsetsWithAnimation(_ animation: Animation?) {
		invalidateDecorationInsetsWithAnimationWrapper(animation?.wrap())
	}


	@nonobjc
	internal func invalidateDecorationInsetsWithAnimationWrapper(_ animationWrapper: Animation.Wrapper?) {
		if decorationInsetsAnimation == nil && appearState == .didAppear {
			decorationInsetsAnimation = animationWrapper
		}

		guard decorationInsetsAreValid else {
			return
		}

		if isInLayout {
			if !needsAdditionalLayoutPass,
				let (innerDecorationInsets, outerDecorationInsets) = computeDecorationInsets(),
				innerDecorationInsets != self.innerDecorationInsets || outerDecorationInsets != self.outerDecorationInsets
			{
				log("Decoration insets changed while laying out \(String(describing: type(of: self))). Another layout pass will be run to apply the new insets.")

				needsAdditionalLayoutPass = true
			}
		}
		else {
			decorationInsetsAreValid = false

			view.setNeedsLayout()
		}
	}


	@nonobjc
	fileprivate static func invalidateTopLevelDecorationInsetsWithAnimation(_ animation: Animation?) {
		let animationWrapper = animation?.wrap()

		for window in UIApplication.shared.windows {
			guard type(of: window) == UIWindow.self || window is _NonSystemWindow || !NSStringFromClass(type(of: window)).hasPrefix("UI") else {
				// ignore system windows like the keyboard
				continue
			}

			var presentedViewController = window.rootViewController
			while let viewController = presentedViewController {
				viewController.invalidateDecorationInsetsWithAnimationWrapper(animationWrapper)
				presentedViewController = viewController.presentedViewController
			}
		}
	}


	@nonobjc
	public func isAncestor(of viewController: UIViewController) -> Bool {
		if viewController === self {
			return true
		}

		guard let viewControllerParent = viewController.parent else {
			return false
		}

		return isAncestor(of: viewControllerParent)
	}


	@nonobjc
	private var isInLayout: Bool {
		get { return (objc_getAssociatedObject(self, &AssociatedKeys.isInLayout) as? NSNumber)?.boolValue ?? false }
		set { objc_setAssociatedObject(self, &AssociatedKeys.isInLayout, newValue ? true : nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}


	@nonobjc
	fileprivate func nameForParentViewController() -> String {
		guard let parentViewController = reliableParentViewController else {
			return "the parent view controller"
		}

		return String(describing: type(of: parentViewController))
	}


	@nonobjc
	private var needsAdditionalLayoutPass: Bool {
		get { return (objc_getAssociatedObject(self, &AssociatedKeys.needsAdditionalLayoutPass) as? NSNumber)?.boolValue ?? false }
		set { objc_setAssociatedObject(self, &AssociatedKeys.needsAdditionalLayoutPass, newValue ? true : nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}


	@objc(JetPack_outerDecorationInsets)
	open private(set) var outerDecorationInsets: UIEdgeInsets {
		get { return (objc_getAssociatedObject(self, &AssociatedKeys.outerDecorationInsets) as? NSValue)?.uiEdgeInsetsValue ?? .zero }
		set { objc_setAssociatedObject(self, &AssociatedKeys.outerDecorationInsets, newValue.isEmpty ? nil : NSValue(uiEdgeInsets: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}


	@nonobjc
	public func presentAlertWithMessage(_ message: String, okayHandler: Closure? = nil) {
		presentAlertWithTitle("", message: message, okayHandler: okayHandler)
	}


	@nonobjc
	public func presentAlertWithTitle(_ title: String, message: String, okayHandler: Closure? = nil) {
		let alertController = UIAlertController(alertWithTitle: title, message: message)
		alertController.addOkayAction(okayHandler)

		presentViewController(alertController)
	}


	@nonobjc
	public func presentViewController(_ viewControllerToPresent: UIViewController, animated: Bool) {
		present(viewControllerToPresent, animated: animated, completion: nil)
	}


	@nonobjc
	public func presentViewController(_ viewControllerToPresent: UIViewController, completion: Closure? = nil) {
		present(viewControllerToPresent, animated: true, completion: completion)
	}


	@nonobjc
	fileprivate var presentingViewControllerForCurrentCoverageCallbacks: UIViewController? {
		get { return objc_getAssociatedObject(self, &AssociatedKeys.presentingViewControllerForCurrentCoverageCallbacks) as? UIViewController }
		set { objc_setAssociatedObject(self, &AssociatedKeys.presentingViewControllerForCurrentCoverageCallbacks, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}


	@nonobjc
	fileprivate var reliableParentViewController: UIViewController? {
		if let parentViewController = parent {
			return parentViewController
		}
		if let splitViewController = splitViewController, splitViewController.viewControllers.first === self {
			// parentViewController may be nil while split view controller's master view controller is displayed as overlay
			return splitViewController
		}

		return nil
	}


	@nonobjc
	fileprivate func reportLifecycleProblem(_ problem: String, possibleCauses: [String]) {
		guard shouldReportLifecycleProblems else {
			return
		}

		var message = "\nVIEW CONTROLLER LIFECYCLE BROKEN for \(self)\n\n"
		message += "Problem:\n\t"
		message += problem
		message += "\n\n"
		message += "Possible Causes:\n"
		message += "\t- "
		message += possibleCauses.joined(separator: "\n\t- ")
		message += "\n"

		print(message)
	}


	@nonobjc
	fileprivate var shouldReportLifecycleProblems: Bool {
		let typeName = NSStringFromClass(type(of: self))
		if typeName.hasPrefix("_") || typeName.hasPrefix("MFMail") || typeName.hasPrefix("MFMessage") || typeName.hasPrefix("PUUI") || typeName.hasPrefix("SFSafari") || typeName.hasPrefix("UICompatibility") || typeName.hasPrefix("UIInput") {
			// broken implementations in public and private UIKit view controllers
			return false
		}

		return true
	}


	@nonobjc
	fileprivate static func subscribeToEvents() {
		let application = UIApplication.shared
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(forName: .UIApplicationDidBecomeActive, object: application, queue: nil, using: applicationDidBecomeActive)
		notificationCenter.addObserver(forName: .UIApplicationWillResignActive, object: application, queue: nil, using: applicationWillResignActive)

		_ = Keyboard.eventBus.subscribe { (_: Keyboard.Event.WillChangeFrame) in
			self.invalidateTopLevelDecorationInsetsWithAnimation(Keyboard.animation)
		}
	}


	@objc(JetPack_didMoveToParentViewController:)
	fileprivate dynamic func swizzled_didMoveToParentViewController(_ parentViewController: UIViewController?) {
		let oldContainmentState = self.containmentState
		let newContainmentState: ContainmentState = parentViewController != nil ? .didMoveToParent : .didMoveFromParent

		if !newContainmentState.isValidSuccessorFor(oldContainmentState) {
			let typeName: String = "\(type(of: self))"

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
		else if parentViewController !== self.parent {
			let newParentName = parentViewController.map { String(describing: $0) } ?? "<nil>"
			let currentParentName = self.parent.map { String(describing: $0) } ?? "<nil>"

			reportLifecycleProblem(".didMoveToParentViewController() was called with parent \(newParentName) but is currently moving to \(currentParentName).", possibleCauses: [ "the view controller containment implementation of \(nameForParentViewController()) or one if its parents is broken" ]
			)
		}
		else if appearState.isTransition {
			var possibleCauses = [ "the view controller containment implementation of \(nameForParentViewController()) or one if its parents is broken" ]

			if appearState == .willAppear && newContainmentState == .didMoveToParent {
				possibleCauses.append("this method was probably called from within the parent's .viewDidAppear() which does not imply that the child did complete it's transition yet")
			}

			reportLifecycleProblem(".didMoveToParentViewController() was called unexpectedly during an appearance transition. It must only be called while the view controller is in \(AppearState.didDisappear) or \(AppearState.didAppear) state.", possibleCauses: possibleCauses)
		}

		self.containmentState = newContainmentState

		swizzled_didMoveToParentViewController(parentViewController)
	}


	@objc(JetPack_presentViewController:animated:completion:)
	fileprivate dynamic func swizzled_presentViewController(_ viewControllerToPresent: UIViewController, animated: Bool, completion: Closure?) {
		swizzled_presentViewController(viewControllerToPresent, animated: animated, completion: completion)

		// workaround for UIKit bug, see http://stackoverflow.com/a/30787046/1183577
		CFRunLoopWakeUp(CFRunLoopGetCurrent())
	}


	@objc(JetPack_setNeedsStatusBarAppearanceUpdate)
	fileprivate dynamic func swizzled_setNeedsStatusBarAppearanceUpdate() {
		swizzled_setNeedsStatusBarAppearanceUpdate()

		UIViewController.invalidateTopLevelDecorationInsetsWithAnimation(Animation.current)
	}


	@objc(JetPack_viewDidAppear:)
	fileprivate dynamic func swizzled_viewDidAppear(_ animated: Bool) {
		self.appearState = .didAppear

		if containmentState == .willMoveToParent {
			onMainQueue(after: 1) {
				guard self.containmentState == .willMoveToParent && self.appearState == .didAppear else {
					return
				}

				self.reportLifecycleProblem(".didMoveToParentViewController(non-nil) was not called after .viewDidAppear() to complete an earlier .willMoveToParentViewController(non-nil).", possibleCauses: [
					"the view controller containment implementation of \(self.nameForParentViewController()) is likely broken"
				])
			}
		}

		if isBeingPresented && reliableParentViewController == nil, let presentingViewController = self.presentingViewController, presentingViewController === presentingViewControllerForCurrentCoverageCallbacks {
			presentingViewController.traverseViewControllerSubtreeFromHereIncludingPresentedViewControllers(false) { viewController in
				guard viewController.appearState == .didAppear else {
					return
				}

				viewController.viewWasCoveredByViewController(self, animated: animated)
			}
		}

		swizzled_viewDidAppear(animated)
	}


	@objc(JetPack_viewDidDisappear:)
	fileprivate dynamic func swizzled_viewDidDisappear(_ animated: Bool) {
		self.appearState = .didDisappear

		if containmentState == .willMoveFromParent {
			onMainQueue(after: 1) {
				guard self.containmentState == .willMoveFromParent && self.appearState == .didDisappear else {
					return
				}

				self.reportLifecycleProblem(".didMoveToParentViewController(nil) was not called after .viewDidDisappear() to complete an earlier .willMoveToParentViewController(nil).", possibleCauses: [
					"the view controller containment implementation of \(self.nameForParentViewController()) is likely broken"
				])
			}
		}

		if isBeingDismissed && reliableParentViewController == nil, let presentingViewController = presentingViewControllerForCurrentCoverageCallbacks {
			presentingViewController.traverseViewControllerSubtreeFromHereIncludingPresentedViewControllers(false) { viewController in
				guard viewController.appearState == .didAppear else {
					return
				}

				viewController.viewWasUncoveredByViewController(self, animated: animated)
			}
		}

		presentingViewControllerForCurrentCoverageCallbacks = nil

		swizzled_viewDidDisappear(animated)
	}


	@objc(JetPack_viewDidLayoutSubviews)
	fileprivate dynamic func swizzled_viewDidLayoutSubviews() {
		swizzled_viewDidLayoutSubviews()

		if let navigationController = self as? UINavigationController {
			navigationController.checkNavigationBarFrame()
		}

		decorationInsetsAnimation = nil
		isInLayout = false

		if needsAdditionalLayoutPass {
			needsAdditionalLayoutPass = false
			view.setNeedsLayout()
		}
	}


	@objc(JetPack_viewWillAppear:)
	fileprivate dynamic func swizzled_viewWillAppear(_ animated: Bool) {
		self.appearState = .willAppear

		if tabBarController != nil, let navigationController = navigationController {
			navigationController.invalidateDecorationInsetsWithAnimation(nil)
		}

		if isBeingPresented && reliableParentViewController == nil, let presentingViewController = self.presentingViewController, let presentationController = presentationController, !presentationController.shouldRemovePresentersView {
			presentingViewControllerForCurrentCoverageCallbacks = presentingViewController

			presentingViewController.traverseViewControllerSubtreeFromHereIncludingPresentedViewControllers(false) { viewController in
				guard viewController.appearState == .didAppear else {
					return
				}

				viewController.viewWillBeCoveredByViewController(self, animated: animated)
			}
		}

		decorationInsetsAnimation = nil
		invalidateDecorationInsetsWithAnimation(nil)

		swizzled_viewWillAppear(animated)
	}


	@objc(JetPack_viewWillDisappear:)
	fileprivate dynamic func swizzled_viewWillDisappear(_ animated: Bool) {
		self.appearState = .willDisappear

		if isBeingDismissed && reliableParentViewController == nil, let presentingViewController = self.presentingViewController, presentingViewController === presentingViewControllerForCurrentCoverageCallbacks {
			presentingViewController.traverseViewControllerSubtreeFromHereIncludingPresentedViewControllers(false) { viewController in
				guard viewController.appearState == .didAppear else {
					return
				}

				viewController.viewWillBeUncoveredByViewController(self, animated: animated)
			}
		}

		swizzled_viewWillDisappear(animated)
	}


	@objc(JetPack_viewWillLayoutSubviews)
	fileprivate dynamic func swizzled_viewWillLayoutSubviews() {
		isInLayout = true
		needsAdditionalLayoutPass = false

		if let (innerDecorationInsets, outerDecorationInsets) = computeDecorationInsets() {
			updateDecorationInsets(inner: innerDecorationInsets, outer: outerDecorationInsets)
		}

		swizzled_viewWillLayoutSubviews()
	}


	@objc(JetPack_willMoveToParentViewController:)
	fileprivate dynamic func swizzled_willMoveToParentViewController(_ parentViewController: UIViewController?) {
		let oldContainmentState = self.containmentState
		let newContainmentState: ContainmentState = parentViewController != nil ? .willMoveToParent : .willMoveFromParent

		if !newContainmentState.isValidSuccessorFor(oldContainmentState) {
			let typeName: String = "\(type(of: self))"

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
			reportLifecycleProblem(".willMoveToParentViewController() was called unexpectedly during an appearance transition. It must only be called while the view controller is in \(AppearState.didDisappear) or \(AppearState.didAppear) state.", possibleCauses: [
				"the view controller containment implementation of \(nameForParentViewController()) or one if its parents is broken",
			])
		}

		self.containmentState = newContainmentState

		swizzled_willMoveToParentViewController(parentViewController)

		if parentViewController != nil {
			invalidateDecorationInsetsWithAnimationWrapper(nil)
		}
	}


	@nonobjc
	fileprivate static func traverseAllViewControllers(_ closure: (UIViewController) -> Void) {
		for window in UIApplication.shared.windows {
			window.rootViewController?.traverseViewControllerSubtreeFromHereIncludingPresentedViewControllers(true, closure: closure)
		}
	}


	@nonobjc
	fileprivate func traverseViewControllerSubtreeFromHereIncludingPresentedViewControllers(_ includesPresentedViewControllers: Bool, closure: (UIViewController) -> Void) {
		closure(self)

		for childViewController in childViewControllers {
			childViewController.traverseViewControllerSubtreeFromHereIncludingPresentedViewControllers(includesPresentedViewControllers, closure: closure)
		}

		if includesPresentedViewControllers {
			presentedViewController?.traverseViewControllerSubtreeFromHereIncludingPresentedViewControllers(true, closure: closure)
		}
	}


	@nonobjc
	private func updateDecorationInsets(inner: UIEdgeInsets, outer: UIEdgeInsets) {
		decorationInsetsAreValid = true

		guard inner != innerDecorationInsets || outer != outerDecorationInsets else {
			return
		}

		innerDecorationInsets = inner
		outerDecorationInsets = outer

		decorationInsetsDidChangeWithAnimation(decorationInsetsAnimation)
	}


	@objc(JetPack_viewDidMoveToWindow)
	public func viewDidMoveToWindow() {
		if window != nil && appearState.isAppear && !decorationInsetsAreValid {
			view.setNeedsLayout()
		}
	}


	@objc(JetPack_viewWasCoveredByViewController:animated:)
	open func viewWasCoveredByViewController(_ viewController: UIViewController, animated: Bool) {
		// override in subclasses
	}


	@objc(JetPack_viewWasUncoveredByViewController:animated:)
	open func viewWasUncoveredByViewController(_ viewController: UIViewController, animated: Bool) {
		// override in subclasses
	}


	@objc(JetPack_viewWillBeCoveredByViewController:animated:)
	open func viewWillBeCoveredByViewController(_ viewController: UIViewController, animated: Bool) {
		// override in subclasses
	}


	@objc(JetPack_viewWillBeUncoveredByViewController:animated:)
	open func viewWillBeUncoveredByViewController(_ viewController: UIViewController, animated: Bool) {
		// override in subclasses
	}


	@nonobjc
	public var window: UIWindow? {
		guard isViewLoaded else {
			return nil
		}

		return view.window
	}
}



// Temporarily moved out of UIViewController extension due to compiler bug.
// See https://travis-ci.org/fluidsonic/JetPack/jobs/93695509
public enum _UIViewControllerAppearState {
	case didDisappear
	case willAppear
	case didAppear
	case willDisappear


	fileprivate init(id: Int) {
		switch id {
		case 0: self = .didDisappear
		case 1: self = .willAppear
		case 2: self = .didAppear
		case 3: self = .willDisappear
		default: fatalError()
		}
	}


	fileprivate var id: Int {
		switch self {
		case .didDisappear:  return 0
		case .willAppear:    return 1
		case .didAppear:     return 2
		case .willDisappear: return 3
		}
	}


	public var isAppear: Bool {
		switch self {
		case .willAppear, .didAppear:       return true
		case .willDisappear, .didDisappear: return false
		}
	}


	public var isDisappear: Bool {
		switch self {
		case .willAppear, .didAppear:       return false
		case .willDisappear, .didDisappear: return true
		}
	}


	public var isTransition: Bool {
		switch self {
		case .willAppear, .willDisappear: return true
		case .didAppear, .didDisappear:   return false
		}
	}
}


extension UIViewController.AppearState: CustomStringConvertible {

	public var description: String {
		switch self {
		case .didAppear:     return "DidAppear"
		case .didDisappear:  return "DidDisappear"
		case .willAppear:    return "WillAppear"
		case .willDisappear: return "WillDisappear"
		}
	}
}



// Temporarily moved out of UIViewController extension due to compiler bug.
// See https://travis-ci.org/fluidsonic/JetPack/jobs/93695509
public enum _UIViewControllerContainmentState {
	case didMoveFromParent
	case willMoveToParent
	case didMoveToParent
	case willMoveFromParent


	fileprivate init(id: Int) {
		switch id {
		case 0: self = .didMoveFromParent
		case 1: self = .willMoveToParent
		case 2: self = .didMoveToParent
		case 3: self = .willMoveFromParent
		default: fatalError()
		}
	}


	fileprivate var id: Int {
		switch self {
		case .didMoveFromParent:  return 0
		case .willMoveToParent:   return 1
		case .didMoveToParent:    return 2
		case .willMoveFromParent: return 3
		}
	}


	public var isInOrMovingToParent: Bool {
		switch self {
		case .willMoveToParent, .didMoveToParent:     return true
		case .willMoveFromParent, .didMoveFromParent: return false
		}
	}


	public var isTransition: Bool {
		switch self {
		case .willMoveToParent, .willMoveFromParent: return true
		case .didMoveToParent, .didMoveFromParent:   return false
		}
	}


	fileprivate func isValidSuccessorFor(_ containmentState: _UIViewControllerContainmentState) -> Bool {
		switch self {
		case .didMoveFromParent:  return (containmentState == .willMoveFromParent)
		case .didMoveToParent:    return (containmentState == .willMoveToParent)
		case .willMoveFromParent: return (containmentState == .willMoveToParent   || containmentState == .didMoveToParent)
		case .willMoveToParent:   return (containmentState == .willMoveFromParent || containmentState == .didMoveFromParent)
		}
	}
}


extension UIViewController.ContainmentState: CustomStringConvertible {

	public var description: String {
		switch self {
		case .didMoveToParent:    return "DidMoveToParent"
		case .didMoveFromParent:  return "DidMoveFromParent"
		case .willMoveToParent:   return "WillMoveToParent"
		case .willMoveFromParent: return "WillMoveFromParent"
		}
	}
}


@objc(_JetPack_Extensions_UIKit_UIViewController_Initialization)
private class StaticInitialization: NSObject, StaticInitializable {

	static func staticInitialize() {
		swizzleMethod(in: UIViewController.self, from: #selector(UIViewController.didMove(toParentViewController:)),  to: #selector(UIViewController.swizzled_didMoveToParentViewController(_:)))
		swizzleMethod(in: UIViewController.self, from: #selector(UIViewController.present(_:animated:completion:)),   to: #selector(UIViewController.swizzled_presentViewController(_:animated:completion:)))
		swizzleMethod(in: UIViewController.self, from: #selector(UIViewController.setNeedsStatusBarAppearanceUpdate), to: #selector(UIViewController.swizzled_setNeedsStatusBarAppearanceUpdate))
		swizzleMethod(in: UIViewController.self, from: #selector(UIViewController.viewDidAppear(_:)),                 to: #selector(UIViewController.swizzled_viewDidAppear(_:)))
		swizzleMethod(in: UIViewController.self, from: #selector(UIViewController.viewDidLayoutSubviews),             to: #selector(UIViewController.swizzled_viewDidLayoutSubviews))
		swizzleMethod(in: UIViewController.self, from: #selector(UIViewController.viewDidDisappear(_:)),              to: #selector(UIViewController.swizzled_viewDidDisappear(_:)))
		swizzleMethod(in: UIViewController.self, from: #selector(UIViewController.viewWillAppear(_:)),                to: #selector(UIViewController.swizzled_viewWillAppear(_:)))
		swizzleMethod(in: UIViewController.self, from: #selector(UIViewController.viewWillDisappear(_:)),             to: #selector(UIViewController.swizzled_viewWillDisappear(_:)))
		swizzleMethod(in: UIViewController.self, from: #selector(UIViewController.viewWillLayoutSubviews),            to: #selector(UIViewController.swizzled_viewWillLayoutSubviews))
		swizzleMethod(in: UIViewController.self, from: #selector(UIViewController.willMove(toParentViewController:)), to: #selector(UIViewController.swizzled_willMoveToParentViewController(_:)))

		UIViewController.subscribeToEvents()
	}
}

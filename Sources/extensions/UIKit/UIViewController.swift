import ObjectiveC
import UIKit


public extension UIViewController {

	private struct AssociatedKeys {
		private static var decorationInsetsAnimation = UInt8()
		private static var decorationInsetsAreValid = UInt8()
		private static var innerDecorationInsets = UInt8()
		private static var outerDecorationInsets = UInt8()
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
	internal static func UIViewController_setUp() {
		swizzleMethodInType(self, fromSelector: "viewDidLayoutSubviews", toSelector: "JetPack_viewDidLayoutSubviews")
		swizzleMethodInType(self, fromSelector: "viewWillAppear:", toSelector: "JetPack_viewWillAppear:")

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


	@objc(JetPack_viewDidLayoutSubviews)
	private func swizzled_viewDidLayoutSubviews() {
		updateDecorationInsets()

		swizzled_viewDidLayoutSubviews()
	}


	@objc(JetPack_viewWillAppear:)
	private func swizzled_viewWillAppear(animated: Bool) {
		// TODO invalidate decoration insets when moving to a window instead of when appearing
		decorationInsetsAnimation = nil
		invalidateDecorationInsetsWithAnimation(nil)

		swizzled_viewWillAppear(animated)
	}


	@nonobjc
	private static func traverseAllViewControllers(closure: UIViewController -> Void) {
		for window in UIApplication.sharedApplication().windows {
			window.rootViewController?.traverseViewControllerSubtreeFromHere(closure)
		}
	}


	@nonobjc
	private func traverseViewControllerSubtreeFromHere(closure: UIViewController -> Void) {
		closure(self)

		for childViewController in childViewControllers {
			childViewController.traverseViewControllerSubtreeFromHere(closure)
		}

		presentedViewController?.traverseViewControllerSubtreeFromHere(closure)
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


	@nonobjc
	public var window: UIWindow? {
		guard isViewLoaded() else {
			return nil
		}

		return view.window
	}
}

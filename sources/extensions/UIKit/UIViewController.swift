import ObjectiveC
import UIKit


public extension UIViewController {

	private struct AssociatedKeys {
		private static var decorationInsetsAreValid = UInt8()
		private static var innerDecorationInsets = UInt8()
		private static var outerDecorationInsets = UInt8()
	}

	private static var needsUpdateDecorationInsets = false



	@objc(JetPack_computeInnerDecorationInsetsForChildViewController:)
	public func computeInnerDecorationInsetsForChildViewController(childViewController: UIViewController) -> UIEdgeInsets {
		return innerDecorationInsets
	}


	@objc(JetPack_computeOuterDecorationInsetsForChildViewController:)
	public func computeOuterDecorationInsetsForChildViewController(childViewController: UIViewController) -> UIEdgeInsets {
		return outerDecorationInsets
	}


	@nonobjc
	private var decorationInsetsAreValid: Bool {
		get { return (objc_getAssociatedObject(self, &AssociatedKeys.decorationInsetsAreValid) as? NSNumber)?.boolValue ?? false }
		set { objc_setAssociatedObject(self, &AssociatedKeys.decorationInsetsAreValid, newValue ? true : nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}


	@objc(JetPack_decorationInsetsDidChangeWithAnimation:)
	public func decorationInsetsDidChangeWithAnimation(animationWrapper: View.Animation.Wrapper?) {
		for childViewController in childViewControllers {
			childViewController.invalidateDecorationInsets()
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
	public func invalidateDecorationInsets() {
		guard decorationInsetsAreValid else {
			return
		}

		decorationInsetsAreValid = false

		if window != nil {
			UIViewController.setNeedsUpdateDecorationInsets()
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
	private static func setNeedsUpdateDecorationInsets() {
		guard !needsUpdateDecorationInsets else {
			return
		}

		needsUpdateDecorationInsets = true

		onMainThread { // delay one cycle
			self.updateDecorationInsetsIfNecessary()
		}
	}


	@nonobjc
	internal static func setUp() {
		swizzleInType(self, fromSelector: "viewWillAppear:", toSelector: "JetPack_viewWillAppear:")
		swizzleInType(self, fromSelector: "viewWillLayoutSubviews", toSelector: "JetPack_viewWillLayoutSubviews")

		subscribeToKeyboardNotifications()
	}


	@nonobjc
	private static func subscribeToKeyboardNotifications() {
		let _ = Keyboard.eventBus.subscribe { (_: Keyboard.Event.WillChangeFrame) in
			self.setNeedsUpdateDecorationInsets()
		}
	}


	@nonobjc
	internal static func updateDecorationInsetsIfNecessary() {
		guard needsUpdateDecorationInsets else {
			return
		}

		for window in UIApplication.sharedApplication().windows {
			guard window.dynamicType == UIWindow.self || window is Window || !NSStringFromClass(window.dynamicType).hasPrefix("UI") else {
				// ignore system windows like the keyboard
				continue
			}

			window.rootViewController?.updateDecorationInsetsRecursively()
		}

		needsUpdateDecorationInsets = false
	}


	@nonobjc
	internal func updateDecorationInsetsRecursively() {
		if let window = window where !decorationInsetsAreValid || parentViewController == nil {
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

			if innerDecorationInsets != self.innerDecorationInsets || outerDecorationInsets != self.outerDecorationInsets {
				self.innerDecorationInsets = innerDecorationInsets
				self.outerDecorationInsets = outerDecorationInsets

				decorationInsetsDidChangeWithAnimation(nil)
			}

			decorationInsetsAreValid = true
		}

		for childViewController in childViewControllers {
			childViewController.updateDecorationInsetsRecursively()
		}

		if let presentedViewController = presentedViewController where presentedViewController !== parentViewController?.presentedViewController {
			presentedViewController.updateDecorationInsetsRecursively()
		}
	}


	@objc(JetPack_viewWillAppear:)
	private func viewWillAppear(animated: Bool) {
		// TODO move this to something like "viewDidMoveToWindow()" as window might not yet be set here
		// or maybe we should test for appearance state instead of window existence?
		UIViewController.setNeedsUpdateDecorationInsets()

		viewWillAppear(animated)
	}


	@objc(JetPack_viewWillLayoutSubviews)
	private func viewWillLayoutSubviews() {
		// TODO probably not a good location to trigger global decoration insets update
		UIViewController.updateDecorationInsetsIfNecessary()

		viewWillLayoutSubviews()
	}


	@nonobjc
	public var window: UIWindow? {
		guard isViewLoaded() else {
			return nil
		}

		return view.window
	}
}

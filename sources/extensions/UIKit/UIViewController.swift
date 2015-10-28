import ObjectiveC
import UIKit


public extension UIViewController {

	private struct AssociatedKeys {
		private static var decorationInsetsAreValid = UInt8()
		private static var innerDecorationInsets = UInt8()
		private static var outerDecorationInsets = UInt8()
	}

	private static var initializeToken = dispatch_once_t()
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


	@objc(JetPack_decorationInsetsDidChangeWithAnimationDuration:animationCurve:)
	public func decorationInsetsDidChangeWithAnimationDuration(animationDuration: NSTimeInterval, animationCurve: UIViewAnimationOptions) {
		// override in subclasses
	}


	@nonobjc
	public func dismissViewController(completion: Closure? = nil) {
		dismissViewControllerAnimated(true, completion: completion)
	}


	@nonobjc
	public func dismissViewControllerAnimated(animated: Bool) {
		dismissViewControllerAnimated(animated, completion: nil)
	}


	@objc
	public override class func initialize() {
		dispatch_once(&initializeToken) {
			swizzleInType(self, fromSelector: "viewWillAppear:", toSelector: "JetPack_viewWillAppear:")
			swizzleInType(self, fromSelector: "viewWillLayoutSubviews", toSelector: "JetPack_viewWillLayoutSubviews")
		}
	}


	@nonobjc
	public private(set) var innerDecorationInsets: UIEdgeInsets {
		get { return (objc_getAssociatedObject(self, &AssociatedKeys.innerDecorationInsets) as? NSValue)?.UIEdgeInsetsValue() ?? .zero }
		set { objc_setAssociatedObject(self, &AssociatedKeys.innerDecorationInsets, newValue.isEmpty ? nil : NSValue(UIEdgeInsets: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}


	@nonobjc
	internal func invalidateDecorationInsets() {
		guard !decorationInsetsAreValid else {
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
	internal static func updateDecorationInsetsIfNecessary() {
		guard needsUpdateDecorationInsets else {
			return
		}

		for window in UIApplication.sharedApplication().windows {
			window.rootViewController?.updateDecorationInsetsRecursively()
		}

		needsUpdateDecorationInsets = false
	}


	@nonobjc
	internal func updateDecorationInsetsRecursively() {
		if window != nil && !decorationInsetsAreValid {
			let innerDecorationInsets: UIEdgeInsets
			let outerDecorationInsets: UIEdgeInsets

			if let parentViewController = parentViewController {
				innerDecorationInsets = parentViewController.computeInnerDecorationInsetsForChildViewController(self)
				outerDecorationInsets = parentViewController.computeOuterDecorationInsetsForChildViewController(self)
			}
			else {
				innerDecorationInsets = UIEdgeInsets(top: topLayoutGuide.length, left: 0, bottom: bottomLayoutGuide.length, right: 0)
				outerDecorationInsets = innerDecorationInsets
			}

			if innerDecorationInsets != self.innerDecorationInsets || outerDecorationInsets != self.outerDecorationInsets {
				self.innerDecorationInsets = innerDecorationInsets
				self.outerDecorationInsets = outerDecorationInsets

				decorationInsetsDidChangeWithAnimationDuration(0, animationCurve: .CurveLinear)
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

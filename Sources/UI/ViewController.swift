import UIKit


@objc(JetPack_ViewController)
open /* non-final */ class ViewController: UIViewController {

	public typealias SeguePreparation = (_ segue: UIStoryboardSegue) -> Void

	fileprivate var viewLayoutAnimation: Animation?
	fileprivate var seguePreparation: SeguePreparation?


	public init() {
		super.init(nibName: nil, bundle: nil)

		// use decorationInsetsDidChangeWithAnimation(_:) instead
		automaticallyAdjustsScrollViewInsets = false
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}


	open func decorationInsetsDidChangeWithAnimation(_ animation: Animation?) {
		for childViewController in childViewControllers {
			childViewController.invalidateDecorationInsetsWithAnimation(animation)
		}
	}


	@available(*, unavailable, message: "override viewDidLayoutSubviewsWithAnimation(_:) instead")
	public final override func decorationInsetsDidChangeWithAnimation(_ animationWrapper: Animation.Wrapper?) {
		decorationInsetsDidChangeWithAnimation(animationWrapper?.animation)
	}


	open override func dismissViewController(animated: Bool = true, completion: Closure? = nil) {
		super.dismiss(animated: animated, completion: completion)
	}


	@available(*, unavailable, renamed: "dismissViewController")
	public final override func dismiss(animated flag: Bool, completion: Closure?) {
		presentedViewController?.dismissViewController(completion: completion)
	}


	open override class func initialize() {
		guard self == ViewController.self else {
			return
		}

		copyMethodInType(object_getClass(self), fromSelector: #selector(overridesPreferredInterfaceOrientationForPresentation), toSelector: obfuscatedSelector("does", "Override", "Preferred", "Interface", "Orientation", "For", "Presentation"))
	}


	open override func loadView() {
		view = View()
		view.frame = UIScreen.main.bounds // required or else UISplitViewController's overlay animation gets broken
	}


	@objc
	fileprivate static func overridesPreferredInterfaceOrientationForPresentation() -> Bool {
		// UIKit will behave differently if we override preferredInterfaceOrientationForPresentation.
		// Let's pretend we don't since we're just re-implementing the default behavior.
		return overridesSelector(#selector(getter: preferredInterfaceOrientationForPresentation), ofBaseClass: ViewController.self)
	}


	open func performSegueWithIdentifier(_ identifier: String, sender: AnyObject? = nil, preparation: SeguePreparation?) {
		seguePreparation = preparation
		defer { seguePreparation = nil }

		performSegue(withIdentifier: identifier, sender: sender)
	}


	open override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
		return ViewController.defaultPreferredInterfaceOrientationForPresentation()
	}


	@available(*, unavailable, message: "override prepareForSegue(_:sender:preparation:) instead")
	public final override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let preparation = seguePreparation
		seguePreparation = nil

		prepareForSegue(segue, sender: sender as AnyObject?, preparation: preparation)
	}


	open func prepareForSegue(_ segue: UIStoryboardSegue, sender: AnyObject?, preparation: SeguePreparation?) {
		preparation?(segue)
	}


	public final func setViewNeedsLayout(animation: Animation? = nil) {
		guard isViewLoaded else {
			return
		}

		viewLayoutAnimation = animation
		view.setNeedsLayout()
	}


	open override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
		return ViewController.defaultSupportedInterfaceOrientationsForModalPresentationStyle(modalPresentationStyle)
	}


	@available(*, unavailable, message: "override viewDidLayoutSubviewsWithAnimation(_:) instead")
	public final override func viewDidLayoutSubviews() {
		let animation = decorationInsetsAnimation?.animation ?? viewLayoutAnimation
		viewLayoutAnimation = nil

		super.viewDidLayoutSubviews()

		viewDidLayoutSubviewsWithAnimation(animation)
	}


	open func viewDidLayoutSubviewsWithAnimation(_ animation: Animation?) {
		// override in subclasses
	}
}

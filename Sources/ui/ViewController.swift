import UIKit


@objc(JetPack_ViewController)
public /* non-final */ class ViewController: UIViewController {

	public typealias SeguePreparation = (segue: UIStoryboardSegue) -> Void

	private var seguePreparation: SeguePreparation?


	public init() {
		super.init(nibName: nil, bundle: nil)

		// use decorationInsetsDidChangeWithAnimation(_:) instead
		automaticallyAdjustsScrollViewInsets = false
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}


	@available(*, deprecated=1, message="override viewDidLayoutSubviewsWithAnimation(_:) instead")
	public func decorationInsetsDidChangeWithAnimation(animation: Animation?) {
		for childViewController in childViewControllers {
			childViewController.invalidateDecorationInsetsWithAnimation(animation)
		}
	}


	@available(*, unavailable, message="override viewDidLayoutSubviewsWithAnimation(_:) instead")
	public final override func decorationInsetsDidChangeWithAnimation(animationWrapper: Animation.Wrapper?) {
		for childViewController in childViewControllers {
			childViewController.invalidateDecorationInsetsWithAnimationWrapper(animationWrapper)
		}
	}


	public override func loadView() {
		view = View()
		view.frame = UIScreen.mainScreen().bounds // required or else UISplitViewController's overlay animation gets broken
	}


	@available(*, unavailable, message="override prepareForSegue(_:sender:preparation:) instead")
	public final override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		let preparation = seguePreparation
		seguePreparation = nil

		prepareForSegue(segue, sender: sender, preparation: preparation)
	}


	public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?, preparation: SeguePreparation?) {
		preparation?(segue: segue)
	}


	public func performSegueWithIdentifier(identifier: String, sender: AnyObject? = nil, preparation: SeguePreparation?) {
		seguePreparation = preparation
		defer { seguePreparation = nil }

		performSegueWithIdentifier(identifier, sender: sender)
	}


	@available(*, unavailable, message="override viewDidLayoutSubviewsWithAnimation(_:) instead")
	public final override func viewDidLayoutSubviews() {
		let animation = decorationInsetsAnimation?.animation

		super.viewDidLayoutSubviews()

		viewDidLayoutSubviewsWithAnimation(animation)
	}


	public func viewDidLayoutSubviewsWithAnimation(animation: Animation?) {
		// override in subclasses
	}
}

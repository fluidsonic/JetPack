import UIKit


public /* non-final */ class ViewController: UIViewController {

	public typealias SeguePreparation = (segue: UIStoryboardSegue) -> Void

	private var seguePreparation: SeguePreparation?


	public init() {
		super.init(nibName: nil, bundle: nil)
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}


	@available(*, unavailable, message="override prepareForSegue(_:sender:preparation) instead")
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
}

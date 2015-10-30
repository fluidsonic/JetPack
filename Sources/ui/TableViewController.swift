import UIKit


public /* non-final */ class TableViewController: UITableViewController {

	public typealias SeguePreparation = ViewController.SeguePreparation

	private var seguePreparation: SeguePreparation?


	public init() {
		super.init(nibName: nil, bundle: nil)
	}


	public override init(style: UITableViewStyle) {
		super.init(style: style)
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}


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

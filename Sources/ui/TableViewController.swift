import UIKit


public /* non-final */ class TableViewController: ViewController {

	private let style: UITableViewStyle


	public init(style: UITableViewStyle) {
		self.style = style

		super.init()
	}


	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	public var automaticallyAdjustsTableViewInsets = true


	public var clearsSelectionOnViewWillAppear = true


	public override func setEditing(editing: Bool, animated: Bool) {
		super.setEditing(editing, animated: animated)

		if isViewLoaded() {
			tableView.setEditing(editing, animated: animated)
		}
	}


	public private(set) lazy var tableView: UITableView = {
		let child = UITableView(frame: .zero, style: self.style)
		child.estimatedRowHeight = 44
		child.dataSource = self
		child.delegate = self

		return child
	}()


	public override func viewDidLayoutSubviewsWithAnimation(animation: Animation?) {
		super.viewDidLayoutSubviewsWithAnimation(animation)

		animation.runAlways {
			if automaticallyAdjustsTableViewInsets {
				tableView.setContentInset(innerDecorationInsets, maintainingVisualContentOffset: true)
				tableView.scrollIndicatorInsets = outerDecorationInsets
			}

			tableView.editing = editing
			tableView.frame = CGRect(size: view.bounds.size)
		}
	}


	public override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		if clearsSelectionOnViewWillAppear, let indexPaths = tableView.indexPathsForSelectedRows {
			for indexPath in indexPaths {
				tableView.deselectRowAtIndexPath(indexPath, animated: animated)
			}
		}
	}


	public override func viewDidLoad() {
		super.viewDidLoad()

		view.addSubview(tableView)
	}
}


extension TableViewController: UITableViewDataSource {

	public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		fatalError("override tableView(_:cellForRowAtIndexPath:) without calling super")
	}


	public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}
}


extension TableViewController: UITableViewDelegate {}

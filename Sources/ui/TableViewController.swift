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


	public override func decorationInsetsDidChangeWithAnimation(animation: UIView.Animation?) {
		super.decorationInsetsDidChangeWithAnimation(animation)

		if automaticallyAdjustsTableViewInsets {
			let initialContentInsets = tableView.contentInset
			let newContentInsets = innerDecorationInsets
			if newContentInsets != initialContentInsets {
				let initialContentOffset = tableView.contentOffset
				tableView.contentInset = innerDecorationInsets

				let newContentOffset = initialContentOffset
					.offsetBy(dy: initialContentInsets.top - newContentInsets.top)
					.clamp(min: tableView.minimumContentOffset, max: tableView.maximumContentOffset)
				if newContentOffset != initialContentOffset {
					tableView.contentOffset = newContentOffset
				}
			}

			tableView.scrollIndicatorInsets = outerDecorationInsets
		}
	}


	public private(set) lazy var tableView: UITableView = {
		let child = UITableView(frame: .zero, style: self.style)
		child.dataSource = self
		child.delegate = self

		return child
	}()


	public override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		tableView.frame = CGRect(size: view.bounds.size)
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
		fatalError("Implement tableView(_:cellForRowAtIndexPath:)")
	}


	public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}
}


extension TableViewController: UITableViewDelegate {}

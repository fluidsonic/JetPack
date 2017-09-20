import UIKit


@objc(JetPack_TableViewController)
open class TableViewController: ViewController {

	fileprivate let style: UITableViewStyle


	public init(style: UITableViewStyle) {
		self.style = style

		super.init()
	}


	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	open var automaticallyAdjustsTableViewInsets = true


	open var clearsSelectionOnViewWillAppear = true


	fileprivate func createTableView() -> TableView {
		let child = TableView(style: style)
		child.estimatedRowHeight = 44
		child.dataSource = self
		child.delegate = self

		return child
	}


	open override func setEditing(_ editing: Bool, animated: Bool) {
		super.setEditing(editing, animated: animated)

		if isViewLoaded {
			tableView.setEditing(editing, animated: animated)
		}
	}


	open fileprivate(set) lazy var tableView: TableView = self.createTableView()


	open override func viewDidLayoutSubviewsWithAnimation(_ animation: Animation?) {
		super.viewDidLayoutSubviewsWithAnimation(animation)

		animation.runAlways {
			if automaticallyAdjustsTableViewInsets {
				tableView.setContentInset(innerDecorationInsets, maintainingVisualContentOffset: true)
				tableView.scrollIndicatorInsets = outerDecorationInsets
			}

			tableView.isEditing = isEditing
			tableView.frame = CGRect(size: view.bounds.size)
		}
	}


	open override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if clearsSelectionOnViewWillAppear, let indexPaths = tableView.indexPathsForSelectedRows {
			for indexPath in indexPaths {
				tableView.deselectRow(at: indexPath, animated: animated)
			}
		}
	}


	open override func viewDidLoad() {
		super.viewDidLoad()

		view.addSubview(tableView)
	}
}


extension TableViewController: UITableViewDataSource {

	open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		fatalError("override tableView(_:cellForRowAt:) without calling super")
	}


	open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}
}


extension TableViewController: UITableViewDelegate {}

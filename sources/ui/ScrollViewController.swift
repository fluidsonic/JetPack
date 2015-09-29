public /* non-final */ class ScrollViewController: ViewController {

	private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
	private lazy var collectionViewLayout = UICollectionViewFlowLayout()
	private var isSettingPrimaryViewControllerInternally = false


	public override init() {
		super.init()
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}


	public var currentIndex: CGFloat {
		let collectionViewWidth = collectionView.bounds.width
		
		guard isViewLoaded() && collectionViewWidth > 0 else {
			return 0
		}

		return collectionView.contentOffset.left / collectionView.bounds.width
	}


	public var primaryViewController: UIViewController? {
		didSet {
			if isSettingPrimaryViewControllerInternally {
				return
			}

			guard let primaryViewController = primaryViewController else {
				fatalError("Cannot set primaryViewController to nil")
			}

			scrollToViewController(primaryViewController, animated: false)
		}
	}


	public func scrollToViewController(viewController: UIViewController, animated: Bool) {
		guard let index = viewControllers.indexOfIdentical(viewController) else {
			fatalError("Cannot scroll to view controller \(viewController) which is not a child view controller")
		}

		if viewController != primaryViewController {
			isSettingPrimaryViewControllerInternally = true
			primaryViewController = viewController
			isSettingPrimaryViewControllerInternally = false
		}

		if isViewLoaded() {
			collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: animated)
		}
	}


	private func setupCollectionView() {
		let layout = collectionViewLayout
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 0
		layout.scrollDirection = .Horizontal

		let child = collectionView
		child.bounces = false
		child.pagingEnabled = true
		child.showsHorizontalScrollIndicator = false
		child.showsVerticalScrollIndicator = false
		child.registerClass(Cell.self, forCellWithReuseIdentifier: "Cell")

		view.addSubview(child)
	}


	private func updatePrimaryViewController() {
		guard isViewLoaded() else {
			return
		}

		var mostVisibleViewController: UIViewController?
		var mostVisibleWidth = CGFloat.min

		let bounds = view.bounds
		for cell in collectionView.visibleCells() {
			guard let cell = cell as? Cell else {
				continue
			}

			let cellFrameInView = cell.convertRect(cell.bounds, toView: view)
			let intersection = cellFrameInView.intersect(bounds)
			guard intersection != .null else {
				continue
			}

			if intersection.width > mostVisibleWidth {
				mostVisibleViewController = cell.viewController
				mostVisibleWidth = intersection.width
			}
		}

		guard mostVisibleViewController != primaryViewController else {
			return
		}

		isSettingPrimaryViewControllerInternally = true
		primaryViewController = mostVisibleViewController
		isSettingPrimaryViewControllerInternally = false
	}


	public var viewControllers = [UIViewController]() {
		didSet {
			guard viewControllers != oldValue else {
				return
			}

			for viewController in oldValue where viewController.parentViewController === self && !viewControllers.containsIdentical(viewController) {
				viewController.willMoveToParentViewController(nil)
				viewController.removeFromParentViewController()
			}

			for viewController in viewControllers where viewController.parentViewController !== self {
				addChildViewController(viewController)
				viewController.didMoveToParentViewController(self)
			}

			if isViewLoaded() {
				collectionView.reloadData()
				updatePrimaryViewController()
			}
			else {
				if let primaryViewController = primaryViewController where viewControllers.containsIdentical(primaryViewController) {
					// primaryViewController still valid
				}
				else {
					primaryViewController = viewControllers.first
				}
			}
		}
	}


	public override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		let viewSize = view.bounds.size
		collectionView.frame = CGRect(size: viewSize)
		collectionViewLayout.itemSize = viewSize

		if collectionView.dataSource == nil {
			if let primaryViewController = primaryViewController, index = viewControllers.indexOfIdentical(primaryViewController) {
				collectionView.contentOffset = CGPoint(left: viewSize.width * CGFloat(index), top: -collectionView.contentInset.top)
			}

			collectionView.dataSource = self
			collectionView.delegate = self
			collectionView.reloadData()
		}
	}


	public override func viewDidLoad() {
		super.viewDidLoad()

		setupCollectionView()
	}
}



extension ScrollViewController: UICollectionViewDataSource {

	public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		precondition(collectionView === self.collectionView)

		let viewController = viewControllers[indexPath.item]

		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! Cell
		cell.viewController = viewController

		return cell
	}


	public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		precondition(collectionView === self.collectionView)

		return viewControllers.count
	}


	public func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
		precondition(collectionView === self.collectionView)

		return false
	}
}


extension ScrollViewController: UICollectionViewDelegate {

	public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
		guard scrollView === collectionView else {
			return
		}

		updatePrimaryViewController()
	}


	public func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
		guard scrollView === collectionView else {
			return
		}

		updatePrimaryViewController()
	}
	

	public func scrollViewDidScroll(scrollView: UIScrollView) {
		guard scrollView === collectionView else {
			return
		}

		if scrollView.tracking {
			updatePrimaryViewController()
		}
	}
}



private final class Cell: UICollectionViewCell {

	private override func layoutSubviews() {
		super.layoutSubviews()

		guard let viewControllerView = viewController?.view else {
			return
		}

		let viewSize = contentView.bounds.size
		viewControllerView.frame = CGRect(size: viewSize)
	}


	private var viewController: UIViewController? {
		didSet {
			guard viewController !== oldValue else {
				return
			}

			if let viewController = oldValue where viewController.isViewLoaded() && viewController.view.superview === contentView {
				viewController.beginAppearanceTransition(false, animated: false)
				viewController.view.removeFromSuperview()
				viewController.endAppearanceTransition()
			}

			if let viewController = viewController {
				viewController.beginAppearanceTransition(true, animated: false)
				contentView.addSubview(viewController.view)
				viewController.endAppearanceTransition()
			}
		}
	}
}

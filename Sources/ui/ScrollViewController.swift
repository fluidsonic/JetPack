import UIKit


public /* non-final */ class ScrollViewController: ViewController {

	public typealias ScrollCompletion = (cancelled: Bool) -> Void

	private var appearState = AppearState.DidDisappear
	private lazy var collectionView: UICollectionView = CollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
	private lazy var collectionViewLayout = UICollectionViewFlowLayout()
	private var isAnimatingScrollView = false
	private var isSettingPrimaryViewControllerInternally = false
	private var scrollCompletion: ScrollCompletion?


	public override init() {
		super.init()

		automaticallyAdjustsScrollViewInsets = false
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)

		automaticallyAdjustsScrollViewInsets = false
	}


	public var currentIndex: CGFloat {
		let collectionViewWidth = collectionView.bounds.width
		
		if isViewLoaded() && collectionViewWidth > 0 {
			return collectionView.contentOffset.left / collectionView.bounds.width
		}
		else if let primaryViewController = primaryViewController, index = viewControllers.indexOfIdentical(primaryViewController) {
			return CGFloat(index)
		}
		else {
			return 0
		}
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


	public func scrollToViewController(viewController: UIViewController, animated: Bool = true, completion: ScrollCompletion? = nil) {
		guard let index = viewControllers.indexOfIdentical(viewController) else {
			fatalError("Cannot scroll to view controller \(viewController) which is not a child view controller")
		}

		if viewController != primaryViewController {
			isSettingPrimaryViewControllerInternally = true
			primaryViewController = viewController
			isSettingPrimaryViewControllerInternally = false
		}

		if isViewLoaded() {
			let previousScrollCompletion = self.scrollCompletion
			scrollCompletion = completion

			collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: animated)

			previousScrollCompletion?(cancelled: true)
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
		child.scrollsToTop = false
		child.showsHorizontalScrollIndicator = false
		child.showsVerticalScrollIndicator = false
		child.registerClass(Cell.self, forCellWithReuseIdentifier: "Cell")

		view.addSubview(child)
	}


	public override func shouldAutomaticallyForwardAppearanceMethods() -> Bool {
		return false
	}


	private func updateAppearStateForAllCellsAnimated(animated: Bool) {
		let visibleCells = collectionView.visibleCells()
		for cell in visibleCells {
			guard let cell = cell as? Cell else {
				continue
			}

			updateAppearStateForCell(cell, animated: animated)
		}

		if let firstResponderCell = collectionView.firstResponderCell as? Cell where !visibleCells.containsIdentical(firstResponderCell) {
			firstResponderCell.endEditing(true)
		}
	}


	private func updateAppearStateForCell(cell: Cell, animated: Bool) {
		var cellAppearState = appearState
		if appearState == .DidAppear && (isAnimatingScrollView || collectionView.tracking || collectionView.decelerating) {
			cellAppearState = .WillAppear
		}

		switch cellAppearState {
		case .DidDisappear, .DidAppear:
			break

		case .WillAppear:
			if cell.appearState == .DidAppear {
				cellAppearState = .DidAppear
			}

		case .WillDisappear:
			if cell.appearState == .DidDisappear {
				cellAppearState = .DidDisappear
			}
		}

		cell.updateAppearState(cellAppearState, animated: animated)
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


	public override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)

		appearState = .DidAppear
		updateAppearStateForAllCellsAnimated(animated)
	}


	public override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)

		appearState = .DidDisappear
		updateAppearStateForAllCellsAnimated(animated)
	}


	public override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		appearState = .WillAppear
		updateAppearStateForAllCellsAnimated(animated)
	}


	public override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)

		appearState = .WillDisappear
		updateAppearStateForAllCellsAnimated(animated)
	}
}



extension ScrollViewController: UICollectionViewDataSource {

	public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		precondition(collectionView === self.collectionView)

		return collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! Cell
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

	public func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
		guard collectionView === self.collectionView else {
			return
		}
		guard let cell = cell as? Cell else {
			return
		}

		cell.updateAppearState(.DidDisappear, animated: false)
		cell.viewController = nil
	}


	public func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
		guard collectionView === self.collectionView else {
			return
		}
		guard let cell = cell as? Cell else {
			return
		}

		cell.viewController = viewControllers[indexPath.item]
		updateAppearStateForCell(cell, animated: true)
	}


	public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
		guard scrollView === collectionView else {
			return
		}

		updateAppearStateForAllCellsAnimated(true)
		updatePrimaryViewController()
	}


	public func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
		guard scrollView === collectionView else {
			return
		}

		isAnimatingScrollView = false

		updateAppearStateForAllCellsAnimated(true)
		updatePrimaryViewController()

		let scrollCompletion = self.scrollCompletion
		self.scrollCompletion = nil

		// TODO not called when scrolling was not necessary
		scrollCompletion?(cancelled: false)
	}


	public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		guard scrollView === collectionView else {
			return
		}

		isAnimatingScrollView = false

		if !decelerate {
			updateAppearStateForAllCellsAnimated(true)
			updatePrimaryViewController()
		}
	}
	

	public func scrollViewDidScroll(scrollView: UIScrollView) {
		guard scrollView === collectionView else {
			return
		}

		if scrollView.tracking {
			updatePrimaryViewController()
		}
	}


	public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
		guard scrollView === collectionView else {
			return
		}

		isAnimatingScrollView = false

		let scrollCompletion = self.scrollCompletion
		self.scrollCompletion = nil

		scrollCompletion?(cancelled: true)
	}


	public func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		guard scrollView === collectionView else {
			return
		}

		isAnimatingScrollView = false
	}
}



private final class Cell: UICollectionViewCell {

	private var appearState = AppearState.DidDisappear


	private override func layoutSubviews() {
		super.layoutSubviews()

		guard let viewControllerView = viewController?.view else {
			return
		}

		let viewSize = contentView.bounds.size
		viewControllerView.frame = CGRect(size: viewSize)
	}


	private func updateAppearState(appearState: AppearState, animated: Bool) {
		let oldAppearState = self.appearState
		guard appearState != oldAppearState else {
			return
		}

		self.appearState = appearState

		guard let viewController = self.viewController else {
			return
		}

		switch appearState {
		case .DidDisappear:
			switch oldAppearState {
			case .DidDisappear:
				break

			case .WillAppear, .DidAppear:
				viewController.beginAppearanceTransition(false, animated: animated)
				fallthrough

			case .WillDisappear:
				viewController.view.removeFromSuperview()
				viewController.endAppearanceTransition()
			}

		case .WillAppear:
			switch oldAppearState {
			case .DidAppear, .WillAppear:
				break

			case .WillDisappear, .DidDisappear:
				viewController.beginAppearanceTransition(true, animated: animated)

				contentView.addSubview(viewController.view)
				setNeedsLayout()
				layoutIfNeeded()
			}

		case .WillDisappear:
			switch oldAppearState {
			case .DidDisappear, .WillDisappear:
				break

			case .WillAppear, .DidAppear:
				viewController.beginAppearanceTransition(false, animated: animated)
			}

		case .DidAppear:
			switch oldAppearState {
			case .DidAppear:
				break

			case .DidDisappear, .WillDisappear:
				viewController.beginAppearanceTransition(true, animated: animated)

				contentView.addSubview(viewController.view)
				setNeedsLayout()
				layoutIfNeeded()
				
				fallthrough

			case .WillAppear:
				viewController.endAppearanceTransition()
			}
		}
	}


	private var viewController: UIViewController? {
		didSet {
			precondition((viewController != nil) != (oldValue != nil))
		}
	}
}



private class CollectionView: UICollectionView {

	private override func setContentOffset(contentOffset: CGPoint, animated: Bool) {
		let willBeginAnimation = animated && contentOffset != self.contentOffset

		super.setContentOffset(contentOffset, animated: animated)

		if willBeginAnimation, let viewController = delegate as? ScrollViewController {
			viewController.isAnimatingScrollView = true
		}
	}
}



private enum AppearState {
	case DidDisappear
	case WillAppear
	case DidAppear
	case WillDisappear
}

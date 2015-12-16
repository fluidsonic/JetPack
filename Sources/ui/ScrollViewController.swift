import UIKit


@objc(JetPack_ScrollViewController)
public /* non-final */ class ScrollViewController: ViewController {

	public typealias ScrollCompletion = (cancelled: Bool) -> Void

	private lazy var childContainer = View()
	private lazy var delegateProxy: DelegateProxy = DelegateProxy(scrollViewController: self)

	private var ignoresScrollViewDidScroll = 0
	private var isSettingPrimaryViewControllerInternally = false
	private var lastLayoutedViewSize = CGSize()
	private var reusableChildView: ChildView?
	private var scrollCompletion: ScrollCompletion?
	private var viewControllersNotYetMovedToParentViewController = [UIViewController]()

	public private(set) final var isInScrollingAnimation = false


	public override init() {
		super.init()
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)

		automaticallyAdjustsScrollViewInsets = false
	}


	private func childViewForIndex(index: Int) -> ChildView? {
		guard isViewLoaded() else {
			return nil
		}

		for subview in childContainer.subviews {
			guard let childView = subview as? ChildView where childView.index == index else {
				continue
			}

			return childView
		}

		return nil
	}


	private func childViewForViewController(viewController: UIViewController) -> ChildView? {
		guard isViewLoaded() else {
			return nil
		}

		for subview in childContainer.subviews {
			guard let childView = subview as? ChildView where childView.viewController === viewController else {
				continue
			}

			return childView
		}

		return nil
	}


	public var currentIndex: CGFloat {
		let scrollViewWidth = scrollView.bounds.width
		
		if isViewLoaded() && scrollViewWidth > 0 {
			return scrollView.contentOffset.left / scrollViewWidth
		}
		else if let primaryViewController = primaryViewController, index = viewControllers.indexOfIdentical(primaryViewController) {
			return CGFloat(index)
		}
		else {
			return 0
		}
	}


	public func didScroll() {
		// override in subclasses
	}


	private var isInTransition: Bool {
		return appearState == .WillAppear || appearState == .WillDisappear || isInScrollingAnimation || scrollView.tracking || scrollView.decelerating
	}


	private func layoutChildContainer() {
		++ignoresScrollViewDidScroll
		defer { --ignoresScrollViewDidScroll }

		let viewSize = view.bounds.size
		let contentSize = CGSize(width: CGFloat(viewControllers.count) * viewSize.width, height: viewSize.height)

		let contentOffset = scrollView.contentOffset
		scrollView.frame = CGRect(size: viewSize)
		childContainer.frame = CGRect(size: contentSize)
		scrollView.contentSize = contentSize
		scrollView.contentOffset = contentOffset
	}


	private func layoutChildView(childView: ChildView) {
		guard childView.index >= 0 else {
			return
		}

		let viewSize = view.bounds.size

		var childViewFrame = CGRect()
		childViewFrame.left = CGFloat(childView.index) * viewSize.width
		childViewFrame.size = viewSize
		childView.frame = childViewFrame
	}


	private func layoutChildrenForcingLayoutUpdate(forcesLayoutUpdate: Bool) {
		++ignoresScrollViewDidScroll
		defer { --ignoresScrollViewDidScroll }

		let viewBounds = view.bounds
		let viewControllers = self.viewControllers
		var contentOffset: CGPoint
		let layoutsExistingChildren: Bool

		let previousViewSize = self.lastLayoutedViewSize
		if forcesLayoutUpdate || viewBounds.size != previousViewSize {
			self.lastLayoutedViewSize = viewBounds.size

			layoutChildContainer()

			contentOffset = scrollView.contentOffset
			var newContentOffset = contentOffset

			if viewControllers.count > 1 {
				var closestChildIndex: Int?
				var closestChildOffset = CGFloat(0)
				var closestDistanceToHorizontalCenter = CGFloat.max

				if !previousViewSize.isEmpty {
					let previousHorizontalCenter = contentOffset.left + (previousViewSize.width / 2)
					for subview in childContainer.subviews {
						guard let childView = subview as? ChildView where childView.index >= 0 else {
							continue
						}

						let childViewFrame = childView.frame
						let distanceToHorizontalCenter = min((previousHorizontalCenter - childViewFrame.left).absolute, (previousHorizontalCenter - childViewFrame.right).absolute)
						guard distanceToHorizontalCenter < closestDistanceToHorizontalCenter else {
							continue
						}

						closestChildIndex = childView.index
						closestChildOffset = (childViewFrame.left - contentOffset.left) / previousViewSize.width
						closestDistanceToHorizontalCenter = distanceToHorizontalCenter
					}
				}

				if let closestChildIndex = closestChildIndex {
					newContentOffset = CGPoint(left: (CGFloat(closestChildIndex) - closestChildOffset) * viewBounds.width, top: 0)
				}
				else if let primaryViewController = primaryViewController, let index = viewControllers.indexOfIdentical(primaryViewController) {
					newContentOffset = CGPoint(left: (CGFloat(index) * viewBounds.width), top: 0)
				}
			}

			newContentOffset = newContentOffset.clamp(min: scrollView.minimumContentOffset, max: scrollView.maximumContentOffset)

			if newContentOffset != contentOffset {
				scrollView.contentOffset = newContentOffset
				contentOffset = newContentOffset
			}

			layoutsExistingChildren = true
		}
		else {
			contentOffset = scrollView.contentOffset
			layoutsExistingChildren = false
		}

		let visibleIndexes: Range<Int>

		if viewControllers.isEmpty || viewBounds.isEmpty {
			visibleIndexes = 0 ..< 0
		}
		else {
			let floatingIndex = contentOffset.left / viewBounds.width
			visibleIndexes = Int(floor(floatingIndex)).clamp(min: 0, max: viewControllers.count - 1) ... Int(ceil(floatingIndex)).clamp(min: 0, max: viewControllers.count - 1)
		}

		for subview in childContainer.subviews {
			guard let childView = subview as? ChildView where !visibleIndexes.contains(childView.index) else {
				continue
			}

			updateChildView(childView, withPreferredAppearState: .WillDisappear, animated: false)
			childView.removeFromSuperview()
			updateChildView(childView, withPreferredAppearState: .DidDisappear, animated: false)

			childView.index = -1
			childView.viewController = nil

			reusableChildView = childView
		}

		for index in visibleIndexes {
			if let childView = childViewForIndex(index) {
				if layoutsExistingChildren {
					layoutChildView(childView)
				}
			}
			else {
				let viewController = viewControllers[index]

				let childView = reusableChildView ?? ChildView()
				childView.index = index
				childView.viewController = viewController

				reusableChildView = nil

				layoutChildView(childView)

				updateChildView(childView, withPreferredAppearState: .WillAppear, animated: false)
				childContainer.addSubview(childView)
				updateChildView(childView, withPreferredAppearState: .DidAppear, animated: false)
			}
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

			scrollView.setContentOffset(CGPoint(left: CGFloat(index) * scrollView.bounds.width, top: 0), animated: true)

			previousScrollCompletion?(cancelled: true)
		}
	}


	public private(set) final lazy var scrollView: UIScrollView = {
		let child = SpecialScrollView()
		child.bounces = false
		child.canCancelContentTouches = true
		child.delaysContentTouches = true
		child.delegate = self.delegateProxy
		child.pagingEnabled = true
		child.scrollsToTop = false
		child.showsHorizontalScrollIndicator = false
		child.showsVerticalScrollIndicator = false

		return child
	}()


	public override func shouldAutomaticallyForwardAppearanceMethods() -> Bool {
		return false
	}


	private func updateAppearStateForAllChildrenAnimated(animated: Bool) {
		for subview in childContainer.subviews {
			guard let childView = subview as? ChildView else {
				continue
			}

			updateChildView(childView, withPreferredAppearState: appearState, animated: animated)
		}
	}


	private func updateChildView(childView: ChildView, withPreferredAppearState preferredAppearState: AppearState, animated: Bool) {
		guard let viewController = childView.viewController else {
			return
		}

		var targetAppearState = min(preferredAppearState, appearState)
		if isInTransition && targetAppearState != .DidDisappear {
			switch childView.appearState {
			case .DidDisappear:  targetAppearState = .WillAppear
			case .WillAppear:    return
			case .DidAppear:     targetAppearState = .WillDisappear
			case .WillDisappear: return
			}
		}

		childView.updateAppearState(targetAppearState, animated: animated)

		if targetAppearState == .DidAppear, let index = viewControllersNotYetMovedToParentViewController.indexOfIdentical(viewController) {
			viewControllersNotYetMovedToParentViewController.removeAtIndex(index)

			onMainQueue { // perform one cycle later since the child may not yet have completed the transitions in this cycle
				if viewController.containmentState == .WillMoveToParent {
					viewController.didMoveToParentViewController(self)
				}
			}
		}
	}


	private func updatePrimaryViewController() {
		guard isViewLoaded() else {
			return
		}

		var mostVisibleViewController: UIViewController?
		var mostVisibleWidth = CGFloat.min

		let bounds = view.bounds
		for subview in childContainer.subviews {
			guard let childView = subview as? ChildView else {
				continue
			}

			let childFrameInView = childView.convertRect(childView.bounds, toView: view)
			let intersection = childFrameInView.intersect(bounds)
			guard !intersection.isNull else {
				continue
			}

			if intersection.width > mostVisibleWidth {
				mostVisibleViewController = childView.viewController
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

			++ignoresScrollViewDidScroll
			defer { --ignoresScrollViewDidScroll }

			var removedViewControllers = [UIViewController]()
			for viewController in oldValue where viewController.parentViewController === self && !viewControllers.containsIdentical(viewController) {
				viewController.willMoveToParentViewController(nil)

				childViewForViewController(viewController)?.index = -1
				removedViewControllers.append(viewController)
				viewControllersNotYetMovedToParentViewController.removeFirstIdentical(viewController)
			}

			for index in 0 ..< viewControllers.count {
				let viewController = viewControllers[index]

				if viewController.parentViewController !== self {
					addChildViewController(viewController)
					viewControllersNotYetMovedToParentViewController.append(viewController)
				}
				else {
					childViewForViewController(viewController)?.index = index
				}
			}

			if isViewLoaded() {
				layoutChildrenForcingLayoutUpdate(true)
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

			for viewController in removedViewControllers {
				viewController.removeFromParentViewController()
			}
		}
	}


	public override func viewDidLayoutSubviewsWithAnimation(animation: Animation?) {
		super.viewDidLayoutSubviewsWithAnimation(animation)

		layoutChildrenForcingLayoutUpdate(true)
		updatePrimaryViewController()
	}


	public override func viewDidLoad() {
		super.viewDidLoad()

		scrollView.addSubview(childContainer)
		view.addSubview(scrollView)
	}


	public override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)

		updateAppearStateForAllChildrenAnimated(animated)
	}


	public override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)

		updateAppearStateForAllChildrenAnimated(animated)
	}


	public override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		updateAppearStateForAllChildrenAnimated(animated)
	}


	public override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)

		updateAppearStateForAllChildrenAnimated(animated)
	}
}



private final class DelegateProxy: NSObject {

	private unowned let scrollViewController: ScrollViewController


	private init(scrollViewController: ScrollViewController) {
		self.scrollViewController = scrollViewController
	}
}


extension DelegateProxy: UIScrollViewDelegate {

	@objc
	private func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
		let scrollViewController = self.scrollViewController

		scrollViewController.updateAppearStateForAllChildrenAnimated(true)
	}


	@objc
	private func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
		let scrollViewController = self.scrollViewController

		scrollViewController.isInScrollingAnimation = false

		scrollViewController.updateAppearStateForAllChildrenAnimated(true)
		scrollViewController.updatePrimaryViewController()

		let scrollCompletion = scrollViewController.scrollCompletion
		scrollViewController.scrollCompletion = nil

		// TODO not called when scrolling was not necessary
		scrollCompletion?(cancelled: false)
	}


	@objc
	private func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		let scrollViewController = self.scrollViewController

		scrollViewController.isInScrollingAnimation = false

		if !decelerate {
			onMainQueue { // loop one cycle because UIScrollView did not yet update .tracking
				scrollViewController.updateAppearStateForAllChildrenAnimated(true)
				scrollViewController.updatePrimaryViewController()
			}
		}
	}
	

	@objc
	private func scrollViewDidScroll(scrollView: UIScrollView) {
		let scrollViewController = self.scrollViewController
		guard scrollViewController.ignoresScrollViewDidScroll == 0 else {
			return
		}

		scrollViewController.layoutChildrenForcingLayoutUpdate(false)

		if scrollView.tracking || scrollView.decelerating {
			scrollViewController.updatePrimaryViewController()
		}

		scrollViewController.didScroll()
	}


	@objc
	private func scrollViewWillBeginDragging(scrollView: UIScrollView) {
		let scrollViewController = self.scrollViewController

		scrollViewController.isInScrollingAnimation = false

		let scrollCompletion = scrollViewController.scrollCompletion
		scrollViewController.scrollCompletion = nil

		scrollViewController.updateAppearStateForAllChildrenAnimated(true)

		scrollCompletion?(cancelled: true)
	}


	@objc
	private func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		scrollViewController.isInScrollingAnimation = false
	}
}



private final class ChildView: View {

	private var appearState = ViewController.AppearState.DidDisappear
	private var index = -1


	private override func layoutSubviews() {
		super.layoutSubviews()

		guard let viewControllerView = viewController?.view else {
			return
		}

		let bounds = self.bounds

		viewControllerView.bounds = CGRect(size: bounds.size)
		viewControllerView.center = bounds.center
	}


	private func updateAppearState(appearState: ViewController.AppearState, animated: Bool) {
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

				addSubview(viewController.view)
				if window != nil {
					layoutIfNeeded()
				}
			}

		case .WillDisappear:
			switch oldAppearState {
			case .DidDisappear, .WillDisappear:
				break

			case .WillAppear, .DidAppear:
				viewController.beginAppearanceTransition(false, animated: animated)
			}

		case .DidAppear:
			assert(window != nil)

			switch oldAppearState {
			case .DidAppear:
				break

			case .DidDisappear, .WillDisappear:
				viewController.beginAppearanceTransition(true, animated: animated)

				addSubview(viewController.view)

				fallthrough

			case .WillAppear:
				layoutIfNeeded()
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



private class SpecialScrollView: ScrollView {

	private override func setContentOffset(contentOffset: CGPoint, animated: Bool) {
		let willBeginAnimation = animated && contentOffset != self.contentOffset

		super.setContentOffset(contentOffset, animated: animated)

		if willBeginAnimation, let viewController = delegate as? ScrollViewController {
			viewController.isInScrollingAnimation = true
		}
	}
}



private func min(a: ViewController.AppearState, _ b: ViewController.AppearState) -> ViewController.AppearState {
	switch a {
	case .DidAppear:
		return b

	case .WillAppear:
		switch b {
		case .DidAppear:
			return a

		default:
			return b
		}

	case .WillDisappear:
		switch b {
		case .DidAppear, .WillAppear:
			return a

		default:
			return b
		}

	case .DidDisappear:
		return a
	}
}

import UIKit


@objc(JetPack_ScrollViewController)
open /* non-final */ class ScrollViewController: ViewController {

	public typealias ScrollCompletion = (_ cancelled: Bool) -> Void

	fileprivate lazy var childContainer = View()
	fileprivate lazy var delegateProxy: DelegateProxy = DelegateProxy(scrollViewController: self)

	fileprivate var ignoresScrollViewDidScroll = 0
	fileprivate var isSettingPrimaryViewControllerInternally = false
	fileprivate var lastLayoutedSize = CGSize.zero
	fileprivate var lastLayoutedSizeForChildren = CGSize.zero
	fileprivate var reusableChildView: ChildView?
	fileprivate var scrollCompletion: ScrollCompletion?
	fileprivate var viewControllersNotYetMovedToParentViewController = [UIViewController]()

	public fileprivate(set) final var isInScrollingAnimation = false


	public override init() {
		super.init()
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)

		automaticallyAdjustsScrollViewInsets = false
	}


	fileprivate func childViewForIndex(_ index: Int) -> ChildView? {
		guard isViewLoaded else {
			return nil
		}

		for subview in childContainer.subviews {
			guard let childView = subview as? ChildView, childView.index == index else {
				continue
			}

			return childView
		}

		return nil
	}


	fileprivate func childViewForViewController(_ viewController: UIViewController) -> ChildView? {
		guard isViewLoaded else {
			return nil
		}

		for subview in childContainer.subviews {
			guard let childView = subview as? ChildView, childView.viewController === viewController else {
				continue
			}

			return childView
		}

		return nil
	}


	fileprivate func createScrollView() -> UIScrollView {
		let child = SpecialScrollView()
		child.bounces = false
		child.canCancelContentTouches = true
		child.delaysContentTouches = true
		child.delegate = self.delegateProxy
		child.isPagingEnabled = true
		child.scrollsToTop = false
		child.showsHorizontalScrollIndicator = false
		child.showsVerticalScrollIndicator = false

		return child
	}


	open var currentIndex: CGFloat {
		let scrollViewWidth = scrollView.bounds.width
		
		if isViewLoaded && scrollViewWidth > 0 {
			return scrollView.contentOffset.left / scrollViewWidth
		}
		else if let primaryViewController = primaryViewController, let index = viewControllers.indexOfIdentical(primaryViewController) {
			return CGFloat(index)
		}
		else {
			return 0
		}
	}


	open func didEndDecelerating() {
		// override in subclasses
	}


	open func didEndDragging(willDecelerate: Bool) {
		// override in subclasses
	}


	open func didScroll() {
		// override in subclasses
	}


	fileprivate var isInTransition: Bool {
		return appearState == .willAppear || appearState == .willDisappear || isInScrollingAnimation || scrollView.isTracking || scrollView.isDecelerating
	}


	fileprivate func layoutChildContainer() {
		ignoresScrollViewDidScroll += 1
		defer { ignoresScrollViewDidScroll -= 1 }

		let viewSize = view.bounds.size
		let contentSize = CGSize(width: CGFloat(viewControllers.count) * viewSize.width, height: viewSize.height)

		let contentOffset = scrollView.contentOffset
		scrollView.frame = CGRect(size: viewSize)
		childContainer.frame = CGRect(size: contentSize)
		scrollView.contentSize = contentSize
		scrollView.contentOffset = contentOffset
	}


	fileprivate func layoutChildView(_ childView: ChildView) {
		guard childView.index >= 0 else {
			return
		}

		let viewSize = view.bounds.size

		var childViewFrame = CGRect()
		childViewFrame.left = CGFloat(childView.index) * viewSize.width
		childViewFrame.size = viewSize
		childView.frame = childViewFrame
	}


	fileprivate func layoutChildrenForcingLayoutUpdate(_ forcesLayoutUpdate: Bool) {
		ignoresScrollViewDidScroll += 1
		defer { ignoresScrollViewDidScroll -= 1 }

		let bounds = view.bounds
		let viewControllers = self.viewControllers
		var contentOffset: CGPoint
		let layoutsExistingChildren: Bool

		let previousViewSize = lastLayoutedSizeForChildren
		if forcesLayoutUpdate || bounds.size != lastLayoutedSizeForChildren {
			lastLayoutedSizeForChildren = bounds.size

			layoutChildContainer()

			contentOffset = scrollView.contentOffset
			var newContentOffset = contentOffset

			if viewControllers.count > 1 {
				var closestChildIndex: Int?
				var closestChildOffset = CGFloat(0)
				var closestDistanceToHorizontalCenter = CGFloat.greatestFiniteMagnitude

				if !previousViewSize.isEmpty {
					let previousHorizontalCenter = contentOffset.left + (previousViewSize.width / 2)
					for subview in childContainer.subviews {
						guard let childView = subview as? ChildView, childView.index >= 0 else {
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
					newContentOffset = CGPoint(left: (CGFloat(closestChildIndex) - closestChildOffset) * bounds.width, top: 0)
				}
				else if let primaryViewController = primaryViewController, let index = viewControllers.indexOfIdentical(primaryViewController) {
					newContentOffset = CGPoint(left: (CGFloat(index) * bounds.width), top: 0)
				}
			}

			newContentOffset = newContentOffset.coerced(min: scrollView.minimumContentOffset, max: scrollView.maximumContentOffset)

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

		let visibleIndexes: CountableRange<Int>

		if viewControllers.isEmpty || bounds.isEmpty {
			visibleIndexes = 0 ..< 0
		}
		else {
			let floatingIndex = contentOffset.left / bounds.width
			visibleIndexes = Int(floatingIndex.rounded(.down)).coerced(in: 0 ... (viewControllers.count - 1)) ..< (Int(floatingIndex.rounded(.up)).coerced(in: 0 ... (viewControllers.count - 1)) + 1)
		}

		for subview in childContainer.subviews {
			guard let childView = subview as? ChildView, !visibleIndexes.contains(childView.index) else {
				continue
			}

			updateChildView(childView, withPreferredAppearState: .willDisappear, animated: false)
			childView.removeFromSuperview()
			updateChildView(childView, withPreferredAppearState: .didDisappear, animated: false)

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

				updateChildView(childView, withPreferredAppearState: .willAppear, animated: false)
				childContainer.addSubview(childView)
				updateChildView(childView, withPreferredAppearState: .didAppear, animated: false)
			}
		}
	}


	open var primaryViewController: UIViewController? {
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


	open func scrollToViewController(_ viewController: UIViewController, animated: Bool = true, completion: ScrollCompletion? = nil) {
		guard let index = viewControllers.indexOfIdentical(viewController) else {
			fatalError("Cannot scroll to view controller \(viewController) which is not a child view controller")
		}

		if viewController != primaryViewController {
			isSettingPrimaryViewControllerInternally = true
			primaryViewController = viewController
			isSettingPrimaryViewControllerInternally = false
		}

		if isViewLoaded {
			let previousScrollCompletion = self.scrollCompletion
			scrollCompletion = completion

			scrollView.setContentOffset(CGPoint(left: CGFloat(index) * scrollView.bounds.width, top: 0), animated: true)

			previousScrollCompletion?(true)
		}
	}


	public fileprivate(set) final lazy var scrollView: UIScrollView = self.createScrollView()


	open override var shouldAutomaticallyForwardAppearanceMethods : Bool {
		return false
	}


	fileprivate func updateAppearStateForAllChildrenAnimated(_ animated: Bool) {
		for subview in childContainer.subviews {
			guard let childView = subview as? ChildView else {
				continue
			}

			updateChildView(childView, withPreferredAppearState: appearState, animated: animated)
		}
	}


	fileprivate func updateChildView(_ childView: ChildView, withPreferredAppearState preferredAppearState: AppearState, animated: Bool) {
		guard let viewController = childView.viewController else {
			return
		}

		var targetAppearState = min(preferredAppearState, appearState)
		if isInTransition && targetAppearState != .didDisappear {
			switch childView.appearState {
			case .didDisappear:  targetAppearState = .willAppear
			case .willAppear:    return
			case .didAppear:     targetAppearState = .willDisappear
			case .willDisappear: return
			}
		}

		childView.updateAppearState(targetAppearState, animated: animated)

		if targetAppearState == .didAppear, let index = viewControllersNotYetMovedToParentViewController.indexOfIdentical(viewController) {
			viewControllersNotYetMovedToParentViewController.remove(at: index)

			onMainQueue { // perform one cycle later since the child may not yet have completed the transitions in this cycle
				if viewController.containmentState == .willMoveToParent {
					viewController.didMove(toParentViewController: self)
				}
			}
		}
	}


	fileprivate func updatePrimaryViewController() {
		guard isViewLoaded else {
			return
		}

		var mostVisibleViewController: UIViewController?
		var mostVisibleWidth = CGFloat.leastNormalMagnitude

		let bounds = view.bounds
		for subview in childContainer.subviews {
			guard let childView = subview as? ChildView else {
				continue
			}

			let childFrameInView = childView.convert(childView.bounds, to: view)
			let intersection = childFrameInView.intersection(bounds)
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


	open var viewControllers = [UIViewController]() {
		didSet {
			guard viewControllers != oldValue else {
				return
			}

			ignoresScrollViewDidScroll += 1
			defer { ignoresScrollViewDidScroll -= 1 }

			var removedViewControllers = [UIViewController]()
			for viewController in oldValue where viewController.parent === self && !viewControllers.containsIdentical(viewController) {
				viewController.willMove(toParentViewController: nil)

				childViewForViewController(viewController)?.index = -1
				removedViewControllers.append(viewController)
				viewControllersNotYetMovedToParentViewController.removeFirstIdentical(viewController)
			}

			for index in 0 ..< viewControllers.count {
				let viewController = viewControllers[index]

				if viewController.parent !== self {
					addChildViewController(viewController)
					viewControllersNotYetMovedToParentViewController.append(viewController)
				}
				else {
					childViewForViewController(viewController)?.index = index
				}
			}

			if isViewLoaded {
				layoutChildrenForcingLayoutUpdate(true)
				updatePrimaryViewController()
			}
			else {
				if let primaryViewController = primaryViewController, viewControllers.containsIdentical(primaryViewController) {
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


	open override func viewDidLayoutSubviewsWithAnimation(_ animation: Animation?) {
		super.viewDidLayoutSubviewsWithAnimation(animation)

		let bounds = view.bounds
		guard bounds.size != lastLayoutedSize else {
			return
		}

		lastLayoutedSize = bounds.size

		layoutChildrenForcingLayoutUpdate(false)
		updatePrimaryViewController()
	}


	open override func viewDidLoad() {
		super.viewDidLoad()

		scrollView.addSubview(childContainer)
		view.addSubview(scrollView)
	}


	open override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		updateAppearStateForAllChildrenAnimated(animated)
	}


	open override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)

		updateAppearStateForAllChildrenAnimated(animated)
	}


	open override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		updateAppearStateForAllChildrenAnimated(animated)
	}


	open override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		updateAppearStateForAllChildrenAnimated(animated)
	}


	open func willBeginDragging() {
		// override in subclasses
	}
}



private final class DelegateProxy: NSObject {

	fileprivate unowned let scrollViewController: ScrollViewController


	fileprivate init(scrollViewController: ScrollViewController) {
		self.scrollViewController = scrollViewController
	}
}


extension DelegateProxy: UIScrollViewDelegate {

	@objc
	fileprivate func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		let scrollViewController = self.scrollViewController

		scrollViewController.updateAppearStateForAllChildrenAnimated(true)
		scrollViewController.didEndDecelerating()
	}


	@objc
	fileprivate func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
		let scrollViewController = self.scrollViewController

		scrollViewController.isInScrollingAnimation = false

		scrollViewController.updateAppearStateForAllChildrenAnimated(true)
		scrollViewController.updatePrimaryViewController()

		let scrollCompletion = scrollViewController.scrollCompletion
		scrollViewController.scrollCompletion = nil

		// TODO not called when scrolling was not necessary
		scrollCompletion?(false)
	}


	@objc
	fileprivate func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		let scrollViewController = self.scrollViewController

		scrollViewController.isInScrollingAnimation = false

		if decelerate {
			scrollViewController.didEndDragging(willDecelerate: true)
		}
		else {
			onMainQueue { // loop one cycle because UIScrollView did not yet update .tracking
				scrollViewController.updateAppearStateForAllChildrenAnimated(true)
				scrollViewController.updatePrimaryViewController()
				scrollViewController.didEndDragging(willDecelerate: false)
			}
		}
	}
	

	@objc
	fileprivate func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let scrollViewController = self.scrollViewController
		guard scrollViewController.ignoresScrollViewDidScroll == 0 else {
			return
		}

		scrollViewController.layoutChildrenForcingLayoutUpdate(false)

		if scrollView.isTracking || scrollView.isDecelerating {
			scrollViewController.updatePrimaryViewController()
		}

		scrollViewController.didScroll()
	}


	@objc
	fileprivate func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		let scrollViewController = self.scrollViewController

		scrollViewController.isInScrollingAnimation = false

		let scrollCompletion = scrollViewController.scrollCompletion
		scrollViewController.scrollCompletion = nil

		scrollViewController.updateAppearStateForAllChildrenAnimated(true)

		scrollCompletion?(true)

		scrollViewController.willBeginDragging()
	}


	@objc
	fileprivate func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		scrollViewController.isInScrollingAnimation = false
	}
}



private final class ChildView: View {

	fileprivate var appearState = ViewController.AppearState.didDisappear
	fileprivate var index = -1


	fileprivate override func layoutSubviews() {
		super.layoutSubviews()

		guard let viewControllerView = viewController?.view else {
			return
		}

		let bounds = self.bounds

		viewControllerView.bounds = CGRect(size: bounds.size)
		viewControllerView.center = bounds.center
	}


	fileprivate func updateAppearState(_ appearState: ViewController.AppearState, animated: Bool) {
		let oldAppearState = self.appearState
		guard appearState != oldAppearState else {
			return
		}

		self.appearState = appearState

		guard let viewController = self.viewController else {
			return
		}

		switch appearState {
		case .didDisappear:
			switch oldAppearState {
			case .didDisappear:
				break

			case .willAppear, .didAppear:
				viewController.beginAppearanceTransition(false, animated: animated)
				fallthrough

			case .willDisappear:
				viewController.view.removeFromSuperview()
				viewController.endAppearanceTransition()
			}

		case .willAppear:
			switch oldAppearState {
			case .didAppear, .willAppear:
				break

			case .willDisappear, .didDisappear:
				viewController.beginAppearanceTransition(true, animated: animated)

				addSubview(viewController.view)
				if window != nil {
					layoutIfNeeded()
				}
			}

		case .willDisappear:
			switch oldAppearState {
			case .didDisappear, .willDisappear:
				break

			case .willAppear, .didAppear:
				viewController.beginAppearanceTransition(false, animated: animated)
			}

		case .didAppear:
			assert(window != nil)

			switch oldAppearState {
			case .didAppear:
				break

			case .didDisappear, .willDisappear:
				viewController.beginAppearanceTransition(true, animated: animated)

				addSubview(viewController.view)

				fallthrough

			case .willAppear:
				layoutIfNeeded()
				viewController.endAppearanceTransition()
			}
		}
	}


	fileprivate var viewController: UIViewController? {
		didSet {
			precondition((viewController != nil) != (oldValue != nil))
		}
	}
}



private class SpecialScrollView: ScrollView {

	fileprivate override func setContentOffset(_ contentOffset: CGPoint, animated: Bool) {
		let willBeginAnimation = animated && contentOffset != self.contentOffset

		super.setContentOffset(contentOffset, animated: animated)

		if willBeginAnimation, let delegate = delegate as? DelegateProxy {
			delegate.scrollViewController.isInScrollingAnimation = true
		}
	}
}



private func min(_ a: ViewController.AppearState, _ b: ViewController.AppearState) -> ViewController.AppearState {
	switch a {
	case .didAppear:
		return b

	case .willAppear:
		switch b {
		case .didAppear:
			return a

		default:
			return b
		}

	case .willDisappear:
		switch b {
		case .didAppear, .willAppear:
			return a

		default:
			return b
		}

	case .didDisappear:
		return a
	}
}

import UIKit


@objc(JetPack_GuideViewController)
public /* non-final */ class GuideViewController: ViewController {

	private lazy var backgroundView = BackgroundView()
	private lazy var focusShadowView = View()
	private var focus: Focus?
	private var handler: Closure?
	private var showInitialGuide: Closure?
	private lazy var tooltipView = TooltipView()


	public override init() {
		super.init()

		modalPresentationCapturesStatusBarAppearance = true
		modalPresentationStyle = .OverFullScreen
		modalTransitionStyle = .CrossDissolve
	}


	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	public var backgroundColor = UIColor(white: 0, alpha: 0.75) {
		didSet {
			if isViewLoaded() {
				backgroundView.backgroundColor = backgroundColor
			}
		}
	}


	public func showGuideWithMessage(message: String, action: String = "OK", focus: Focus, handler: Closure) {
		if isViewLoaded() {
			showInitialGuide = nil

			tooltipView.buttonText = action
			tooltipView.labelText = message

			let animated = (self.focus != nil)

			self.focus = focus
			self.handler = handler

			view.setNeedsLayout()

			if animated {
				Animation(duration: 0.6).run {
					view.layoutIfNeeded()
				}
			}
		}
		else {
			showInitialGuide = { [unowned self] in
				self.showGuideWithMessage(message, action: action, focus: focus, handler: handler)
			}
		}
	}


	public var padding = UIEdgeInsets(all: 15) {
		didSet {
			guard padding != oldValue else {
				return
			}

			view.setNeedsLayout()
		}
	}


	public override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}


	public override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
		return .Fade
	}


	public weak var touchableView: UIView? {
		didSet {
			if isViewLoaded() {
				backgroundView.nextHitTestView = touchableView
			}
		}
	}


	public override func viewDidLoad() {
		super.viewDidLoad()

		setupBackgroundView()
		setupFocusShadowView()
		setupTooltipView()
	}


	private func setupBackgroundView() {
		let child = backgroundView
		child.backgroundColor = backgroundColor
		child.nextHitTestView = touchableView

		view.addSubview(child)
	}


	private func setupTooltipView() {
		let child = tooltipView
		child.buttonTapped = { [unowned self] in
			self.handler?()
		}

		view.addSubview(child)
	}


	private func setupFocusShadowView() {
		let child = focusShadowView
		child.shadowColor = UIColor.blackColor()
		child.shadowOffset = .zero
		child.shadowOpacity = 0.15
		child.shadowRadius = 2
		child.userInteractionEnabled = false

		backgroundView.addSubview(child)
	}


	public override func viewDidLayoutSubviewsWithAnimation(animation: Animation?) {
		super.viewDidLayoutSubviewsWithAnimation(animation)

		let viewSize = view.bounds.size

		backgroundView.frame = CGRect(size: viewSize)
		focusShadowView.frame = CGRect(size: viewSize)

		guard let focus = focus else {
			return
		}

		let focusPath: UIBezierPath
		switch focus {
		case let .Rectangle(frame, cornerRadius, referenceView):
			focusPath = UIBezierPath(animatableRoundedRect: referenceView.convertRect(frame, toCoordinateSpace: view), cornerRadii: CornerRadii(all: cornerRadius))
		}

		backgroundView.focusPath = focusPath
		focusShadowView.shadowPath = focusPath

		var tooltipViewFrame = CGRect()
		tooltipViewFrame.size = tooltipView.sizeThatFitsWidth(viewSize.width - padding.left - padding.right, allowsTruncation: true)

		let focusFrame = focusPath.bounds
		if focusFrame.verticalCenter < viewSize.height / 2 {
			tooltipViewFrame.top = focusFrame.bottom + 4
			tooltipView.additionalHitZone = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
			tooltipView.arrowDirection = .Up
		}
		else {
			tooltipViewFrame.bottom = focusFrame.top - 4
			tooltipView.additionalHitZone = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
			tooltipView.arrowDirection = .Down
		}

		let minimumContentFrameLeft = padding.left
		let maximumContentFrameRight = viewSize.width - padding.right

		tooltipViewFrame.horizontalCenter = focusFrame.horizontalCenter
		tooltipViewFrame.left = max(minimumContentFrameLeft, tooltipViewFrame.left)
		tooltipViewFrame.right = min(maximumContentFrameRight, tooltipViewFrame.right)

		tooltipView.frame = tooltipViewFrame
		tooltipView.arrowOffset = tooltipView.convertPoint(focusFrame.center, fromView: view).left
	}


	public override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		if let showInitialGuide = showInitialGuide {
			self.showInitialGuide = nil
			showInitialGuide()
		}
	}



	public enum Focus {
		case Rectangle(CGRect, cornerRadius: CGFloat, referenceView: UIView)
	}
}



private final class BackgroundView: View {

	private let mask = ShapeView()

	private weak var nextHitTestView: UIView?


	private override init() {
		super.init()

		layer.mask = mask.layer
	}


	private required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	private var focusPath: UIBezierPath? {
		didSet {
			mask.path = (focusPath?.invertedBezierPathInRect(bounds) ?? UIBezierPath(rect: bounds))
		}
	}


	private override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
		var hitView = super.hitTest(point, withEvent: event)
		if hitView === self, let focusPath = focusPath where focusPath.containsPoint(point) {
			hitView = nil
		}
		if hitView == nil, let nextHitTestView = nextHitTestView {
			hitView = nextHitTestView.hitTest(nextHitTestView.convertPoint(point, fromCoordinateSpace: self), withEvent: event)
		}

		return hitView
	}


	private override func layoutSubviews() {
		super.layoutSubviews()

		mask.frame = bounds
	}
}

import UIKit


@objc(JetPack_GuideViewController)
open /* non-final */ class GuideViewController: ViewController {

	fileprivate lazy var backgroundView = BackgroundView()
	fileprivate lazy var focusShadowView = View()
	fileprivate var focus: Focus?
	fileprivate var handler: Closure?
	fileprivate var showInitialGuide: Closure?
	fileprivate lazy var tooltipView = TooltipView()


	public override init() {
		super.init()

		modalPresentationCapturesStatusBarAppearance = true
		modalPresentationStyle = .overFullScreen
		modalTransitionStyle = .crossDissolve
	}


	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	open var backgroundColor = UIColor(white: 0, alpha: 0.75) {
		didSet {
			if isViewLoaded {
				backgroundView.backgroundColor = backgroundColor
			}
		}
	}


	open func showGuideWithMessage(_ message: String, action: String = "OK", focus: Focus, handler: @escaping Closure) {
		if isViewLoaded {
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


	open var padding = UIEdgeInsets(all: 15) {
		didSet {
			guard padding != oldValue else {
				return
			}

			view.setNeedsLayout()
		}
	}


	open override var preferredStatusBarStyle : UIStatusBarStyle {
		return .lightContent
	}


	open override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
		return .fade
	}


	open weak var touchableView: UIView? {
		didSet {
			if isViewLoaded {
				backgroundView.nextHitTestView = touchableView
			}
		}
	}


	open override func viewDidLoad() {
		super.viewDidLoad()

		setupBackgroundView()
		setupFocusShadowView()
		setupTooltipView()
	}


	fileprivate func setupBackgroundView() {
		let child = backgroundView
		child.backgroundColor = backgroundColor
		child.nextHitTestView = touchableView

		view.addSubview(child)
	}


	fileprivate func setupTooltipView() {
		let child = tooltipView
		child.buttonTapped = { [unowned self] in
			self.handler?()
		}

		view.addSubview(child)
	}


	fileprivate func setupFocusShadowView() {
		let child = focusShadowView
		child.shadowColor = UIColor.black
		child.shadowOffset = .zero
		child.shadowOpacity = 0.15
		child.shadowRadius = 2
		child.isUserInteractionEnabled = false

		backgroundView.addSubview(child)
	}


	open override func viewDidLayoutSubviewsWithAnimation(_ animation: Animation?) {
		super.viewDidLayoutSubviewsWithAnimation(animation)

		let viewSize = view.bounds.size

		backgroundView.frame = CGRect(size: viewSize)
		focusShadowView.frame = CGRect(size: viewSize)

		guard let focus = focus else {
			return
		}

		let focusPath: UIBezierPath
		switch focus {
		case let .rectangle(frame, cornerRadius, referenceView):
			focusPath = UIBezierPath(animatableRoundedRect: referenceView.convert(frame, to: view), cornerRadii: CornerRadii(all: cornerRadius))
		}

		backgroundView.focusPath = focusPath
		focusShadowView.shadowPath = focusPath

		var tooltipViewFrame = CGRect()
		tooltipViewFrame.size = tooltipView.sizeThatFitsWidth(viewSize.width - padding.left - padding.right, allowsTruncation: true)

		let focusFrame = focusPath.bounds
		if focusFrame.verticalCenter < viewSize.height / 2 {
			tooltipViewFrame.top = focusFrame.bottom + 4
			tooltipView.additionalHitZone = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
			tooltipView.arrowDirection = .up
		}
		else {
			tooltipViewFrame.bottom = focusFrame.top - 4
			tooltipView.additionalHitZone = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
			tooltipView.arrowDirection = .down
		}

		let minimumContentFrameLeft = padding.left
		let maximumContentFrameRight = viewSize.width - padding.right

		tooltipViewFrame.horizontalCenter = focusFrame.horizontalCenter
		tooltipViewFrame.left = max(minimumContentFrameLeft, tooltipViewFrame.left)
		tooltipViewFrame.right = min(maximumContentFrameRight, tooltipViewFrame.right)

		tooltipView.frame = tooltipViewFrame
		tooltipView.arrowOffset = tooltipView.convert(focusFrame.center, from: view).left
	}


	open override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if let showInitialGuide = showInitialGuide {
			self.showInitialGuide = nil
			showInitialGuide()
		}
	}



	public enum Focus {
		case rectangle(CGRect, cornerRadius: CGFloat, referenceView: UIView)
	}
}



private final class BackgroundView: View {

	fileprivate let shapeMask = ShapeView()

	fileprivate weak var nextHitTestView: UIView?


	fileprivate override init() {
		super.init()

		layer.mask = shapeMask.layer
	}


	fileprivate required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	fileprivate var focusPath: UIBezierPath? {
		didSet {
			shapeMask.path = (focusPath?.invertedBezierPathInRect(bounds) ?? UIBezierPath(rect: bounds))
		}
	}


	fileprivate override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		var hitView = super.hitTest(point, with: event)
		if hitView === self, let focusPath = focusPath, focusPath.contains(point) {
			hitView = nil
		}
		if hitView == nil, let nextHitTestView = nextHitTestView {
			hitView = nextHitTestView.hitTest(nextHitTestView.convert(point, from: self), with: event)
		}

		return hitView
	}


	fileprivate override func layoutSubviews() {
		super.layoutSubviews()

		shapeMask.frame = bounds
	}
}

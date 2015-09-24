public /* non-final */ class GuideViewController: UIViewController {

	private lazy var backgroundView = BackgroundView()
	private lazy var contentView = ContentView()
	private lazy var focusShadowView = View()
	private var focus: Focus?
	private var handler: Closure?
	private var showInitialGuide: Closure?


	public init() {
		super.init(nibName: nil, bundle: nil)

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

			contentView.buttonText = action
			contentView.labelText = message

			let animated = (self.focus != nil)

			self.focus = focus
			self.handler = handler

			view.setNeedsLayout()

			if animated {
				View.Animation(duration: 0.6).run {
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
		setupContentView()
		setupFocusShadowView()
	}


	private func setupBackgroundView() {
		let child = backgroundView
		child.backgroundColor = backgroundColor
		child.nextHitTestView = touchableView

		view.addSubview(child)
	}


	private func setupContentView() {
		let child = contentView
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


	public override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		let viewSize = view.bounds.size

		backgroundView.frame = CGRect(size: viewSize)
		focusShadowView.frame = CGRect(size: viewSize)

		guard let focus = focus else {
			return
		}

		let focusPath: UIBezierPath
		switch focus {
		case let .Rectangle(frame, cornerRadius, referenceView):
			focusPath = UIBezierPath(animatableRoundedRect: referenceView.convertRect(frame, toCoordinateSpace: view), cornerRadius: cornerRadius)
		}

		backgroundView.focusPath = focusPath
		focusShadowView.shadowPath = focusPath

		var contentViewFrame = CGRect()
		contentViewFrame.size = contentView.sizeThatFitsWidth(viewSize.width - padding.left - padding.right, allowsTruncation: true)

		let focusFrame = focusPath.bounds
		if focusFrame.verticalCenter < viewSize.height / 2 {
			contentViewFrame.top = focusFrame.bottom + 4
			contentView.additionalHitZone = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
			contentView.arrowDirection = .Up
		}
		else {
			contentViewFrame.bottom = focusFrame.top - 4
			contentView.additionalHitZone = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
			contentView.arrowDirection = .Down
		}

		let minimumContentFrameLeft = padding.left
		let maximumContentFrameRight = viewSize.width - padding.right

		contentViewFrame.horizontalCenter = focusFrame.horizontalCenter
		contentViewFrame.left = max(minimumContentFrameLeft, contentViewFrame.left)
		contentViewFrame.right = min(maximumContentFrameRight, contentViewFrame.right)

		contentView.frame = contentViewFrame
		contentView.arrowOffset = contentView.convertPoint(focusFrame.center, fromView: view).left
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


	#if TARGET_INTERFACE_BUILDER
		public required convenience init(frame: CGRect) {
			self.init()

			self.frame = frame
		}
	#endif


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



private final class ContentView: View {

	private let arrowSize = CGSize(width: 12, height: 8)
	private let backgroundCornerRadius = CGFloat(3)
	private let backgroundView = ShapeView()
	private let button = Button()
	private let label = Label()
	private let separator = View()


	private override init() {
		super.init()

		setup()
	}


	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	#if TARGET_INTERFACE_BUILDER
		public required convenience init(frame: CGRect) {
			self.init()

			self.frame = frame
		}
	#endif


	private var arrowDirection = ArrowDirection.Up {
		didSet {
			guard arrowDirection != oldValue else {
				return
			}

			setNeedsLayout()
		}
	}


	private var arrowOffset = CGFloat(0) {
		didSet {
			guard arrowOffset != oldValue else {
				return
			}

			setNeedsLayout()
		}
	}


	private var buttonTapped: Closure?


	private var buttonText: String {
		get { return button.textLabel.text ?? "" }
		set {
			guard newValue != buttonText else {
				return
			}

			button.textLabel.text = newValue

			setNeedsLayout()
		}
	}


	private var labelText: String {
		get { return label.text ?? "" }
		set {
			guard newValue != labelText else {
				return
			}

			label.text = newValue

			setNeedsLayout()
		}
	}


	private override func layoutSubviews() {
		super.layoutSubviews()

		let viewSize = bounds.size
		let innerTop = (arrowDirection == .Up ? arrowSize.height : 0)
		let innerBottom = viewSize.height - (arrowDirection == .Down ? arrowSize.height : 0)

		var right = viewSize.width - padding.right

		let arrowOffset = self.arrowOffset.clamp(min: backgroundView.cornerRadius + (arrowSize.width / 2), max: viewSize.width - backgroundView.cornerRadius - (arrowSize.width / 2))

		let backgroundPath = UIBezierPath()
		backgroundPath.moveToPoint(CGPoint(left: arrowOffset - (arrowSize.width / 2), top: innerTop))
		backgroundPath.addLineToPoint(CGPoint(left: arrowOffset, top: (arrowDirection == .Up ? 0 : innerTop)))
		backgroundPath.addLineToPoint(CGPoint(left: arrowOffset + (arrowSize.width / 2), top: innerTop))
		backgroundPath.addLineToPoint(CGPoint(left: viewSize.width - backgroundCornerRadius, top: innerTop))
		backgroundPath.addRoundedCorner(direction: .RightDown, radius: backgroundCornerRadius)
		backgroundPath.addLineToPoint(CGPoint(left: viewSize.width, top: innerBottom - backgroundCornerRadius))
		backgroundPath.addRoundedCorner(direction: .DownLeft, radius: backgroundCornerRadius)
		backgroundPath.addLineToPoint(CGPoint(left: arrowOffset + (arrowSize.width / 2), top: innerBottom))
		backgroundPath.addLineToPoint(CGPoint(left: arrowOffset, top: (arrowDirection == .Down ? viewSize.height : innerBottom)))
		backgroundPath.addLineToPoint(CGPoint(left: arrowOffset - (arrowSize.width / 2), top: innerBottom))
		backgroundPath.addLineToPoint(CGPoint(left: backgroundCornerRadius, top: innerBottom))
		backgroundPath.addRoundedCorner(direction: .LeftUp, radius: backgroundCornerRadius)
		backgroundPath.addLineToPoint(CGPoint(left: 0, top: innerTop + backgroundCornerRadius))
		backgroundPath.addRoundedCorner(direction: .UpRight, radius: backgroundCornerRadius)
		backgroundPath.closePath()

		backgroundView.frame = CGRect(size: viewSize)
		backgroundView.path = backgroundPath

		var buttonFrame = CGRect()
		buttonFrame.width = button.widthThatFits()
		buttonFrame.right = right
		buttonFrame.top = innerTop + padding.top
		buttonFrame.height = innerBottom - padding.bottom - buttonFrame.top
		button.frame = roundScaled(buttonFrame)
		button.additionalHitZone = UIEdgeInsets(top: padding.top + 20, left: separatorPadding.right + 20, bottom: padding.bottom + 20, right: padding.right + 20)

		right = buttonFrame.left - separatorPadding.right

		var separatorFrame = CGRect()
		separatorFrame.width = roundScaled(1)
		separatorFrame.right = right
		separatorFrame.top = innerTop + separatorPadding.top
		separatorFrame.height = innerBottom - separatorPadding.bottom - separatorFrame.top
		separator.frame = roundScaled(separatorFrame)

		right = separatorFrame.left - separatorPadding.left

		var labelFrame = CGRect()
		labelFrame.left = padding.left
		labelFrame.top = innerTop + padding.top
		labelFrame.width = right - labelFrame.left
		labelFrame.height = innerBottom - padding.bottom - labelFrame.top
		label.frame = roundScaled(labelFrame)
	}


	private var padding = UIEdgeInsets(all: 12) {
		didSet {
			guard padding != oldValue else {
				return
			}

			setNeedsLayout()
		}
	}


	private var separatorPadding = UIEdgeInsets(all: 10) {
		didSet {
			guard separatorPadding != oldValue else {
				return
			}

			setNeedsLayout()
		}
	}


	private func setup() {
		clipsToBounds = false

		setupBackgroundView()
		setupButton()
		setupLabel()
		setupSeparator()
	}


	private func setupBackgroundView() {
		let child = backgroundView
		child.clipsToBounds = false
		child.fillColor = .whiteColor()
		child.shadowColor = .blackColor()
		child.shadowOffset = .zero
		child.shadowOpacity = 0.15
		child.shadowRadius = 2

		addSubview(child)
	}


	private func setupButton() {
		let child = button
		child.textLabel.font = UIFont.boldSystemFontOfSize(UIFont.smallSystemFontSize() * 1.1)
		child.tapped = { [unowned self] in
			self.buttonTapped?()
		}

		addSubview(child)
	}


	private func setupLabel() {
		let child = label
		child.numberOfLines = 0
		child.alpha = 0.87
		child.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize() * 1.1)
		child.textColor = .blackColor()

		addSubview(child)
	}


	private func setupSeparator() {
		let child = separator
		child.alpha = 0.12
		child.backgroundColor = .blackColor()

		addSubview(child)
	}


	private override func sizeThatFitsSize(maximumSize: CGSize) -> CGSize {
		let horizontalPadding = padding.left + separatorPadding.left + separatorPadding.right + padding.right
		let verticalPadding = padding.top + padding.bottom

		var remainingSize = CGSize(width: maximumSize.width - horizontalPadding, height: maximumSize.height - verticalPadding)
		guard remainingSize.width > 0 && remainingSize.height > 0 else {
			return .zero
		}

		let buttonSize = button.sizeThatFitsSize(remainingSize)
		remainingSize.width -= buttonSize.width

		let labelSize = label.sizeThatFitsSize(remainingSize)

		let separatorWidth = roundScaled(1)
		let arrowHeight = arrowSize.height

		let fittingSize = CGSize(width: labelSize.width + separatorWidth + buttonSize.width + horizontalPadding, height: max(labelSize.height, buttonSize.height) + verticalPadding + arrowHeight)
		return ceilScaled(fittingSize)
	}



	private enum ArrowDirection {
		case Up
		case Down
	}
}

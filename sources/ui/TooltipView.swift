public /* non-final */ class TooltipView: View {

	private let arrowSize = CGSize(width: 12, height: 8)
	private let backgroundCornerRadius = CGFloat(3)
	private let backgroundView = ShapeView()
	private let button = Button()
	private let label = Label()
	private let separator = View()


	public override init() {
		super.init()

		setup()
	}


	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	#if TARGET_INTERFACE_BUILDER
		public convenience init(frame: CGRect) {
			self.init()

			self.frame = frame
		}
	#endif


	public var arrowDirection = ArrowDirection.Up {
		didSet {
			guard arrowDirection != oldValue else {
				return
			}

			setNeedsLayout()
		}
	}


	public var arrowOffset = CGFloat(0) {
		didSet {
			guard arrowOffset != oldValue else {
				return
			}

			setNeedsLayout()
		}
	}


	public var buttonTapped: Closure?


	public var buttonText: String {
		get { return button.textLabel.text ?? "" }
		set {
			guard newValue != buttonText else {
				return
			}

			button.textLabel.text = newValue

			setNeedsLayout()
		}
	}


	public var labelText: String {
		get { return label.text ?? "" }
		set {
			guard newValue != labelText else {
				return
			}

			label.text = newValue

			setNeedsLayout()
		}
	}


	public override func layoutSubviews() {
		super.layoutSubviews()

		let viewSize = bounds.size
		let innerTop = (arrowDirection == .Up ? arrowSize.height : 0)
		let innerBottom = viewSize.height - (arrowDirection == .Down ? arrowSize.height : 0)

		var right = viewSize.width - padding.right

		let arrowOffset = self.arrowOffset.clamp(min: backgroundCornerRadius + (arrowSize.width / 2), max: viewSize.width - backgroundCornerRadius - (arrowSize.width / 2))

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


	public var padding = UIEdgeInsets(all: 12) {
		didSet {
			guard padding != oldValue else {
				return
			}

			setNeedsLayout()
		}
	}


	public var separatorPadding = UIEdgeInsets(all: 10) {
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


	public override func sizeThatFitsSize(maximumSize: CGSize) -> CGSize {
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
	
	
	
	public enum ArrowDirection {
		case Up
		case Down
	}
}

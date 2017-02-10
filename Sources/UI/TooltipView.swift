import UIKit


@objc(JetPack_TooltipView)
open class TooltipView: View {

	fileprivate let arrowSize = CGSize(width: 12, height: 8)
	fileprivate let backgroundCornerRadius = CGFloat(3)
	fileprivate let backgroundView = ShapeView()
	fileprivate let button = Button()
	fileprivate let label = Label()
	fileprivate let separator = View()


	public override init() {
		super.init()

		setup()
	}


	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	open var arrowDirection = ArrowDirection.up {
		didSet {
			guard arrowDirection != oldValue else {
				return
			}

			setNeedsLayout()
		}
	}


	open var arrowOffset = CGFloat(0) {
		didSet {
			guard arrowOffset != oldValue else {
				return
			}

			setNeedsLayout()
		}
	}


	open var buttonTapped: Closure?


	open var buttonText: String {
		get { return button.textLabel.text }
		set {
			guard newValue != buttonText else {
				return
			}

			button.textLabel.text = newValue

			setNeedsLayout()
		}
	}


	open var labelText: String {
		get { return label.text }
		set {
			guard newValue != labelText else {
				return
			}

			label.text = newValue

			setNeedsLayout()
		}
	}


	open override func layoutSubviews() {
		super.layoutSubviews()

		let viewSize = bounds.size
		let innerTop = (arrowDirection == .up ? arrowSize.height : 0)
		let innerBottom = viewSize.height - (arrowDirection == .down ? arrowSize.height : 0)

		var right = viewSize.width - padding.right

		let arrowOffset = self.arrowOffset.coerced(in: (backgroundCornerRadius + (arrowSize.width / 2)) ... (viewSize.width - backgroundCornerRadius - (arrowSize.width / 2)))

		let backgroundPath = UIBezierPath()
		backgroundPath.move(to: CGPoint(left: arrowOffset - (arrowSize.width / 2), top: innerTop))
		backgroundPath.addLine(to: CGPoint(left: arrowOffset, top: (arrowDirection == .up ? 0 : innerTop)))
		backgroundPath.addLine(to: CGPoint(left: arrowOffset + (arrowSize.width / 2), top: innerTop))
		backgroundPath.addLine(to: CGPoint(left: viewSize.width - backgroundCornerRadius, top: innerTop))
		backgroundPath.addRoundedCorner(direction: .rightDown, radius: backgroundCornerRadius)
		backgroundPath.addLine(to: CGPoint(left: viewSize.width, top: innerBottom - backgroundCornerRadius))
		backgroundPath.addRoundedCorner(direction: .downLeft, radius: backgroundCornerRadius)
		backgroundPath.addLine(to: CGPoint(left: arrowOffset + (arrowSize.width / 2), top: innerBottom))
		backgroundPath.addLine(to: CGPoint(left: arrowOffset, top: (arrowDirection == .down ? viewSize.height : innerBottom)))
		backgroundPath.addLine(to: CGPoint(left: arrowOffset - (arrowSize.width / 2), top: innerBottom))
		backgroundPath.addLine(to: CGPoint(left: backgroundCornerRadius, top: innerBottom))
		backgroundPath.addRoundedCorner(direction: .leftUp, radius: backgroundCornerRadius)
		backgroundPath.addLine(to: CGPoint(left: 0, top: innerTop + backgroundCornerRadius))
		backgroundPath.addRoundedCorner(direction: .upRight, radius: backgroundCornerRadius)
		backgroundPath.close()

		backgroundView.frame = CGRect(size: viewSize)
		backgroundView.path = backgroundPath

		var buttonFrame = CGRect()
		buttonFrame.width = button.widthThatFits()
		buttonFrame.right = right
		buttonFrame.top = innerTop + padding.top
		buttonFrame.height = innerBottom - padding.bottom - buttonFrame.top
		button.frame = alignToGrid(buttonFrame)
		button.additionalHitZone = UIEdgeInsets(top: padding.top + 20, left: separatorPadding.right + 20, bottom: padding.bottom + 20, right: padding.right + 20)

		right = buttonFrame.left - separatorPadding.right

		var separatorFrame = CGRect()
		separatorFrame.width = roundToGrid(1)
		separatorFrame.right = right
		separatorFrame.top = innerTop + separatorPadding.top
		separatorFrame.height = innerBottom - separatorPadding.bottom - separatorFrame.top
		separator.frame = alignToGrid(separatorFrame)

		right = separatorFrame.left - separatorPadding.left

		var labelFrame = CGRect()
		labelFrame.left = padding.left
		labelFrame.top = innerTop + padding.top
		labelFrame.width = right - labelFrame.left
		labelFrame.height = innerBottom - padding.bottom - labelFrame.top
		label.frame = alignToGrid(labelFrame)
	}


	open var padding = UIEdgeInsets(all: 12) {
		didSet {
			guard padding != oldValue else {
				return
			}

			setNeedsLayout()
		}
	}


	open var separatorPadding = UIEdgeInsets(all: 10) {
		didSet {
			guard separatorPadding != oldValue else {
				return
			}

			setNeedsLayout()
		}
	}


	fileprivate func setup() {
		clipsToBounds = false

		setupBackgroundView()
		setupButton()
		setupLabel()
		setupSeparator()
	}


	fileprivate func setupBackgroundView() {
		let child = backgroundView
		child.clipsToBounds = false
		child.fillColor = .white
		child.shadowColor = .black
		child.shadowOffset = .zero
		child.shadowOpacity = 0.15
		child.shadowRadius = 2

		addSubview(child)
	}


	fileprivate func setupButton() {
		let child = button
		child.textLabel.font = UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize * 1.1)
		child.tapped = { [unowned self] in
			self.buttonTapped?()
		}

		addSubview(child)
	}


	fileprivate func setupLabel() {
		let child = label
		child.alpha = 0.87
		child.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize * 1.1)
		child.maximumNumberOfLines = nil
		child.textColor = .black

		addSubview(child)
	}


	fileprivate func setupSeparator() {
		let child = separator
		child.alpha = 0.12
		child.backgroundColor = .black

		addSubview(child)
	}


	open override func sizeThatFitsSize(_ maximumSize: CGSize) -> CGSize {
		let horizontalPadding = padding.left + separatorPadding.left + separatorPadding.right + padding.right
		let verticalPadding = padding.top + padding.bottom

		var remainingSize = CGSize(width: maximumSize.width - horizontalPadding, height: maximumSize.height - verticalPadding)
		guard remainingSize.width > 0 && remainingSize.height > 0 else {
			return .zero
		}

		let buttonSize = button.sizeThatFitsSize(remainingSize)
		remainingSize.width -= buttonSize.width

		let labelSize = label.sizeThatFitsSize(remainingSize)

		let separatorWidth = roundToGrid(1)
		let arrowHeight = arrowSize.height

		let fittingSize = CGSize(width: labelSize.width + separatorWidth + buttonSize.width + horizontalPadding, height: max(labelSize.height, buttonSize.height) + verticalPadding + arrowHeight)
		return alignToGrid(fittingSize)
	}
	
	
	
	public enum ArrowDirection {
		case up
		case down
	}
}

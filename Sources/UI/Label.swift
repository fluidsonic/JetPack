import UIKit


@objc(JetPack_Label)
open class Label: View {

	private lazy var delegateProxy: DelegateProxy = DelegateProxy(label: self)

	private let linkTapRecognizer = UITapGestureRecognizer()
	private let textLayer = TextLayer()

	open var linkTapped: ((URL) -> Void)?


	public override init() {
		super.init()

		clipsToBounds = false

		textLayer.contentsScale = gridScaleFactor
		layer.addSublayer(textLayer)

		setUpLinkTapRecognizer()
	}


	@available(*, deprecated: 1, message: "Use init() instead of init(highPrecision: true) since this is the new default. 'false' is deprecated.", renamed: "init()")
	public convenience init(highPrecision: Bool) {
		self.init()

		textLayer.highPrecision = highPrecision
	}


	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	open var additionalLinkHitZone: UIEdgeInsets {
		get { return textLayer.additionalLinkHitZone }
		set { textLayer.additionalLinkHitZone = newValue }
	}


	open var attributedText: NSAttributedString {
		get { return textLayer.attributedText }
		set {
			guard newValue != textLayer.attributedText else {
				return
			}

			textLayer.attributedText = newValue

			invalidateIntrinsicContentSize()
			setNeedsLayout()
		}
	}


	open override func didMoveToWindow() {
		super.didMoveToWindow()

		if window != nil {
			textLayer.contentsScale = gridScaleFactor
		}
	}


	open var font: UIFont {
		get { return textLayer.font }
		set {
			guard newValue != textLayer.font else {
				return
			}

			textLayer.font = newValue

			invalidateIntrinsicContentSize()
			setNeedsLayout()
		}
	}


	@objc
	private func handleLinkTapRecognizer() {
		guard let link = link(at: linkTapRecognizer.location(in: self)) else {
			return
		}

		linkTapped?(link)
	}


	open var horizontalAlignment: TextAlignment.Horizontal {
		get { return textLayer.horizontalAlignment }
		set {
			guard newValue != textLayer.horizontalAlignment else {
				return
			}

			textLayer.horizontalAlignment = newValue

			setNeedsLayout()
		}
	}


	open var kerning: TextKerning? {
		get { return textLayer.kerning }
		set {
			guard newValue != textLayer.kerning else {
				return
			}

			textLayer.kerning = newValue

			invalidateIntrinsicContentSize()
			setNeedsLayout()
		}
	}


	open override func layoutSubviews() {
		super.layoutSubviews()

		let maximumTextLayerFrame = bounds.insetBy(padding)
		guard maximumTextLayerFrame.size.isPositive else {
			textLayer.isHidden = true
			return
		}

		textLayer.isHidden = false

		var textLayerFrame = CGRect()
		textLayerFrame.size = textLayer.textSize(thatFits: maximumTextLayerFrame.size)

		switch horizontalAlignment {
		case .left,
		     .natural where effectiveUserInterfaceLayoutDirection == .leftToRight:
			textLayerFrame.left = maximumTextLayerFrame.left

		case .center:
			textLayerFrame.horizontalCenter = maximumTextLayerFrame.horizontalCenter

		case .right, .natural:
			textLayerFrame.right = maximumTextLayerFrame.right

		case .justified:
			textLayerFrame.left = maximumTextLayerFrame.left
			textLayerFrame.width = maximumTextLayerFrame.width
		}

		textLayer.textSize = textLayerFrame.size

		switch verticalAlignment {
		case .top:    textLayerFrame.top = maximumTextLayerFrame.top
		case .center: textLayerFrame.verticalCenter = maximumTextLayerFrame.verticalCenter
		case .bottom: textLayerFrame.bottom = maximumTextLayerFrame.bottom
		}

		textLayerFrame.insetInPlace(textLayer.contentInsets)
		textLayer.frame = alignToGrid(textLayerFrame)
	}


	open var lineBreakMode: NSLineBreakMode {
		get { return textLayer.lineBreakMode }
		set {
			guard newValue != textLayer.lineBreakMode else {
				return
			}

			textLayer.lineBreakMode = newValue

			invalidateIntrinsicContentSize()
			setNeedsLayout()
		}
	}


	open var lineHeightMultiple: CGFloat {
		get { return textLayer.lineHeightMultiple }
		set {
			guard newValue != textLayer.lineHeightMultiple else {
				return
			}

			textLayer.lineHeightMultiple = newValue

			invalidateIntrinsicContentSize()
			setNeedsLayout()
		}
	}


	public func link(at point: CGPoint) -> URL? {
		return textLayer.link(at: layer.convert(point, to: textLayer))?.url
	}


	open var maximumLineHeight: CGFloat? {
		get { return textLayer.maximumLineHeight }
		set {
			guard newValue != textLayer.maximumLineHeight else {
				return
			}

			textLayer.maximumLineHeight = newValue

			invalidateIntrinsicContentSize()
			setNeedsLayout()
		}
	}


	open var maximumNumberOfLines: Int? {
		get { return textLayer.maximumNumberOfLines }
		set {
			guard newValue != textLayer.maximumNumberOfLines else {
				return
			}

			textLayer.maximumNumberOfLines = newValue

			invalidateIntrinsicContentSize()
			setNeedsLayout()
		}
	}


	open override func measureOptimalSize(forAvailableSize availableSize: CGSize) -> CGSize {
		let availableSize = availableSize.insetBy(padding)
		guard availableSize.isPositive else {
			return .zero
		}

		return textLayer.textSize(thatFits: availableSize).insetBy(padding.inverse)
	}


	open var minimumLineHeight: CGFloat? {
		get { return textLayer.minimumLineHeight }
		set {
			guard newValue != textLayer.minimumLineHeight else {
				return
			}

			textLayer.minimumLineHeight = newValue

			invalidateIntrinsicContentSize()
			setNeedsLayout()
		}
	}


	open var minimumScaleFactor: CGFloat {
		get { return textLayer.minimumScaleFactor }
		set {
			guard newValue != textLayer.minimumScaleFactor else {
				return
			}

			textLayer.minimumScaleFactor = newValue

			invalidateIntrinsicContentSize()
			setNeedsLayout()
		}
	}


	open var numberOfLines: Int {
		layoutIfNeeded()

		return textLayer.numberOfLines
	}


	open var padding = UIEdgeInsets.zero {
		didSet {
			guard padding != oldValue else {
				return
			}

			invalidateIntrinsicContentSize()
			setNeedsLayout()
		}
	}


	open override func pointInside(_ point: CGPoint, withEvent event: UIEvent?, additionalHitZone: UIEdgeInsets) -> Bool {
		let isInsideLabel = super.pointInside(point, withEvent: event, additionalHitZone: additionalHitZone)
		guard isInsideLabel || textLayer.contains(layer.convert(point, to: textLayer)) else {
			return false
		}
		guard userInteractionLimitedToLinks else {
			return isInsideLabel
		}

		return link(at: point) != nil
	}


	public func rect(forLine line: Int, in referenceView: UIView) -> CGRect {
		layoutIfNeeded()

		return textLayer.rect(forLine: line, in: referenceView.layer)
	}


	private func setUpLinkTapRecognizer() {
		let recognizer = linkTapRecognizer
		recognizer.delegate = delegateProxy
		recognizer.addTarget(self, action: #selector(handleLinkTapRecognizer))

		addGestureRecognizer(recognizer)
	}


	open var text: String {
		get { return attributedText.string }
		set { attributedText = NSAttributedString(string: newValue) }
	}


	open var textColor: UIColor {
		get { return textLayer.normalTextColor }
		set { textLayer.normalTextColor = newValue }
	}


	public var textColorDimsWithTint: Bool {
		get { return textLayer.textColorDimsWithTint }
		set { textLayer.textColorDimsWithTint = newValue }
	}


	open var textTransform: TextTransform? {
		get { return textLayer.textTransform }
		set {
			guard newValue != textLayer.textTransform else {
				return
			}

			textLayer.textTransform = newValue

			invalidateIntrinsicContentSize()
			setNeedsLayout()
		}
	}


	open override func tintColorDidChange() {
		super.tintColorDidChange()

		textLayer.updateTintColor(tintColor, adjustmentMode: tintAdjustmentMode)
	}


	open var userInteractionLimitedToLinks = true


	open var verticalAlignment = TextAlignment.Vertical.center {
		didSet {
			guard verticalAlignment != oldValue else {
				return
			}

			setNeedsLayout()
		}
	}


	private final class DelegateProxy: NSObject, UIGestureRecognizerDelegate {

		private unowned var label: Label


		init(label: Label) {
			self.label = label
		}


		@objc
		func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
			return label.link(at: touch.location(in: label)) != nil
		}
	}
}

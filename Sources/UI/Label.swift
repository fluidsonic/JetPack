import UIKit


open class Label: View {

	private lazy var delegateProxy: DelegateProxy = DelegateProxy(label: self)

	private let linkTapRecognizer = UITapGestureRecognizer()

	open var linkTapped: ((URL) -> Void)?


	public override init() {
		super.init()

		isOpaque = false
		layer.contentsScale = gridScaleFactor

		setUpLinkTapRecognizer()
	}


	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	open var additionalLinkHitZone: UIEdgeInsets {
		get { return labelLayer.additionalLinkHitZone }
		set { labelLayer.additionalLinkHitZone = newValue }
	}


	open var attributedText: NSAttributedString {
		get { return labelLayer.attributedText }
		set {
			guard newValue != labelLayer.attributedText else {
				return
			}

			labelLayer.attributedText = newValue

			invalidateIntrinsicContentSize()
		}
	}


	open override func didMoveToWindow() {
		super.didMoveToWindow()

		if window != nil {
			layer.contentsScale = gridScaleFactor
		}
		else {
			layer.removeAllAnimations()
		}
	}


	open var font: UIFont {
		get { return labelLayer.font }
		set {
			guard newValue != labelLayer.font else {
				return
			}

			labelLayer.font = newValue

			invalidateIntrinsicContentSize()
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
		get { return labelLayer.horizontalAlignment }
		set { labelLayer.horizontalAlignment = newValue }
	}


	@available(*, deprecated, renamed: "letterSpacing")
	open var kerning: TextLetterSpacing? {
		get { return letterSpacing }
		set { letterSpacing = newValue }
	}


	private var labelLayer: LabelLayer {
		return layer as! LabelLayer
	}


	public final override class var layerClass: AnyObject.Type {
		return LabelLayer.self
	}


	open var letterSpacing: TextLetterSpacing? {
		get { return labelLayer.letterSpacing }
		set {
			guard newValue != labelLayer.letterSpacing else {
				return
			}

			labelLayer.letterSpacing = letterSpacing

			invalidateIntrinsicContentSize()
		}
	}


	open var lineBreakMode: NSLineBreakMode {
		get { return labelLayer.lineBreakMode }
		set {
			guard newValue != labelLayer.lineBreakMode else {
				return
			}

			labelLayer.lineBreakMode = newValue

			invalidateIntrinsicContentSize()
		}
	}


	open var lineHeight: TextLineHeight {
		get { return labelLayer.lineHeight }
		set {
			guard newValue != labelLayer.lineHeight else {
				return
			}

			labelLayer.lineHeight = newValue

			invalidateIntrinsicContentSize()
		}
	}


	public func link(at point: CGPoint) -> URL? {
		return labelLayer.link(at: layer.convert(point, to: labelLayer))?.url
	}


	open var maximumLineHeight: CGFloat? {
		get { return labelLayer.maximumLineHeight }
		set {
			guard newValue != labelLayer.maximumLineHeight else {
				return
			}

			labelLayer.maximumLineHeight = newValue

			invalidateIntrinsicContentSize()
		}
	}


	open var maximumNumberOfLines: Int? {
		get { return labelLayer.maximumNumberOfLines }
		set {
			guard newValue != labelLayer.maximumNumberOfLines else {
				return
			}

			labelLayer.maximumNumberOfLines = newValue

			invalidateIntrinsicContentSize()
		}
	}


	open override func measureOptimalSize(forAvailableSize availableSize: CGSize) -> CGSize {
		guard availableSize.isPositive else {
			return .zero
		}

		return labelLayer.size(thatFits: availableSize)
	}


	open var minimumLineHeight: CGFloat? {
		get { return labelLayer.minimumLineHeight }
		set {
			guard newValue != labelLayer.minimumLineHeight else {
				return
			}

			labelLayer.minimumLineHeight = newValue

			invalidateIntrinsicContentSize()
		}
	}


	open var minimumScaleFactor: CGFloat {
		get { return labelLayer.minimumScaleFactor }
		set {
			guard newValue != labelLayer.minimumScaleFactor else {
				return
			}

			labelLayer.minimumScaleFactor = newValue

			invalidateIntrinsicContentSize()
		}
	}


	open var numberOfLines: Int {
		return labelLayer.numberOfLines
	}


	open var padding: UIEdgeInsets {
		get { return labelLayer.padding }
		set {
			guard newValue != labelLayer.padding else {
				return
			}

			labelLayer.padding = newValue

			invalidateIntrinsicContentSize()
		}
	}


	open var paragraphSpacing: CGFloat {
		get { return labelLayer.paragraphSpacing }
		set {
			guard newValue != labelLayer.paragraphSpacing else {
				return
			}

			labelLayer.paragraphSpacing = newValue

			invalidateIntrinsicContentSize()
		}
	}


	open override func pointInside(_ point: CGPoint, withEvent event: UIEvent?, additionalHitZone: UIEdgeInsets) -> Bool {
		let isInsideLabel = super.pointInside(point, withEvent: event, additionalHitZone: additionalHitZone)
		guard isInsideLabel || labelLayer.contains(layer.convert(point, to: labelLayer)) else {
			return false
		}
		guard userInteractionLimitedToLinks else {
			return isInsideLabel
		}

		return link(at: point) != nil
	}


	public func rect(forLine line: Int, in referenceView: UIView) -> CGRect {
		return labelLayer.rect(forLine: line, in: referenceView.layer)
	}


	private func setUpLinkTapRecognizer() {
		let recognizer = linkTapRecognizer
		recognizer.delegate = delegateProxy
		recognizer.addTarget(self, action: #selector(handleLinkTapRecognizer))

		addGestureRecognizer(recognizer)
	}


	open override func shouldAnimateProperty(_ property: String) -> Bool {
		if super.shouldAnimateProperty(property) {
			return true
		}

		switch property {
		case "actualTextColor", "actualTintColor":
			return true

		default:
			return false
		}
	}


	open var text: String {
		get { return attributedText.string }
		set { attributedText = NSAttributedString(string: newValue) }
	}


	open var textColor: UIColor {
		get { return labelLayer.normalTextColor }
		set { labelLayer.normalTextColor = newValue }
	}


	public var textColorDimsWithTint: Bool {
		get { return labelLayer.textColorDimsWithTint }
		set { labelLayer.textColorDimsWithTint = newValue }
	}


	open var textTransform: TextTransform? {
		get { return labelLayer.textTransform }
		set {
			guard newValue != labelLayer.textTransform else {
				return
			}

			labelLayer.textTransform = newValue

			invalidateIntrinsicContentSize()
		}
	}


	public var treatsLineFeedAsParagraphSeparator: Bool {
		get { return labelLayer.treatsLineFeedAsParagraphSeparator }
		set { labelLayer.treatsLineFeedAsParagraphSeparator = newValue }
	}


	open override func tintColorDidChange() {
		super.tintColorDidChange()

		labelLayer.updateTintColor(tintColor, adjustmentMode: tintAdjustmentMode)
	}


	open var userInteractionLimitedToLinks = true


	open var verticalAlignment: TextAlignment.Vertical {
		get { return labelLayer.verticalAlignment }
		set { labelLayer.verticalAlignment = newValue }
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

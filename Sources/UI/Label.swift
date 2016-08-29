import UIKit


@objc(JetPack_Label)
public /* non-final */ class Label: View {

	private lazy var delegateProxy: DelegateProxy = DelegateProxy(label: self)
	private lazy var renderingLayer: LabelLayer = self.layer as! LabelLayer

	private var attributedTextUsesTintColor = false
	private let layoutManager = LayoutManager()
	private let linkTapRecognizer = UITapGestureRecognizer()
	private let textContainer = NSTextContainer()
	private let textStorage = NSTextStorage()

	public private(set) var lastDrawnFinalizedText: NSAttributedString?
	public private(set) var lastUsedFinalTextColor: CGColor?

	public var additionalLinkHitZone = UIEdgeInsets(all: 8) // TODO don't use UIEdgeInsets because actually we outset
	public var linkTapped: (NSURL -> Void)?


	public override init() {
		super.init()

		additionalHitZone = additionalLinkHitZone
		contentMode = .Redraw
		opaque = false

		layoutManager.addTextContainer(textContainer)

		textContainer.lineFragmentPadding = 0
		textContainer.maximumNumberOfLines = maximumNumberOfLines ?? 0
		textContainer.lineBreakMode = lineBreakMode

		textStorage.addLayoutManager(layoutManager)

		setUpLinkTapRecognizer()
	}


	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	@NSCopying
	public var attributedText = NSAttributedString() {
		didSet {
			guard attributedText != oldValue else {
				return
			}

			invalidateIntrinsicContentSize()
			setNeedsUpdateFinalizedText()
		}
	}


	public override func didMoveToWindow() {
		super.didMoveToWindow()

		guard let window = window else {
			return
		}

		layer.contentsScale = window.screen.scale
	}


	public override func drawLayer(layer: CALayer, inContext context: CGContext) {
		super.drawLayer(layer, inContext: context)

		guard let layer = layer as? LabelLayer else {
			return
		}

		renderingLayer = layer
		lastDrawnFinalizedText = finalizeText()

		UIGraphicsPushContext(context)
		defer { UIGraphicsPopContext() }

		let textContainerOrigin = originForTextContainer()
		let glyphRange = layoutManager.glyphRangeForTextContainer(textContainer)
		layoutManager.drawBackgroundForGlyphRange(glyphRange, atPoint: textContainerOrigin)
		layoutManager.drawGlyphsForGlyphRange(glyphRange, atPoint: textContainerOrigin)
	}


	public override func drawRect(rect: CGRect) {
		// Although we use drawLayer(_:inContext:) we still need to implement this method.
		// UIKit checks for its presence when it decides whether a call to setNeedsDisplay() is forwarded to its layer.
	}


	public var font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody) {
		didSet {
			guard font != oldValue else {
				return
			}

			invalidateIntrinsicContentSize()
			setNeedsUpdateFinalizedText()
		}
	}


	private func finalTextColorDidChange() {
		setNeedsUpdateFinalizedText()
	}


	private func finalizeText() -> NSAttributedString {
		let finalTextColor = renderingLayer.finalTextColor // can change due to animation
		if finalTextColor != lastUsedFinalTextColor {
			lastUsedFinalTextColor = finalTextColor
		}
		else if let finalizedText = _finalizedText {
			return finalizedText
		}

		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = horizontalAlignment
		paragraphStyle.lineBreakMode = .ByWordWrapping
		paragraphStyle.lineHeightMultiple = lineHeightMultiple

		var defaultAttributes = [
			NSFontAttributeName: font,
			NSForegroundColorAttributeName: UIColor(CGColor: finalTextColor),
			NSParagraphStyleAttributeName: paragraphStyle
		]

		if let kerning = kerning {
			let kerningValue: CGFloat
			switch kerning {
			case let .Absolute(value): kerningValue = value
			case let .Relative(value): kerningValue = font.pointSize * value
			}

			defaultAttributes[NSKernAttributeName] = kerningValue
		}

		let attributedText = self.attributedText
		let finalizedText = NSMutableAttributedString(string: attributedText.string, attributes: defaultAttributes)

		var attributedTextUsesTintColor = false
		var hasLinks = false
		let tintColor = self.tintColor

		attributedText.enumerateAttributesInRange(NSRange(forString: finalizedText.string), options: [.LongestEffectiveRangeNotRequired]) { attributes, range, _ in
			var finalAttributes = attributes
			if !hasLinks && attributes[NSLinkAttributeName] != nil {
				hasLinks = true
			}

			if let backgroundColor = attributes[NSBackgroundColorAttributeName] as? UIColor where backgroundColor.tintAlpha != nil {
				finalAttributes[NSBackgroundColorAttributeName] = backgroundColor.tintedWithColor(tintColor)
				attributedTextUsesTintColor = true
			}
			if let foregroundColor = attributes[NSForegroundColorAttributeName] as? UIColor where foregroundColor.tintAlpha != nil {
				finalAttributes[NSForegroundColorAttributeName] = foregroundColor.tintedWithColor(tintColor)
				attributedTextUsesTintColor = true
			}

			finalizedText.addAttributes(finalAttributes, range: range)
		}

		textStorage.setAttributedString(finalizedText)
		linkTapRecognizer.enabled = hasLinks

		self.attributedTextUsesTintColor = attributedTextUsesTintColor

		_finalizedText = finalizedText.copy() as? NSAttributedString
		_links = nil
		_numberOfLines = nil

		return finalizedText
	}


	private var _finalizedText: NSAttributedString?
	public final var finalizedText: NSAttributedString {
		return finalizeText()
	}


	@objc
	private func handleLinkTapRecognizer() {
		guard let link = linkAtPoint(linkTapRecognizer.locationInView(self)) else {
			return
		}

		linkTapped?(link.url)
	}


	public var horizontalAlignment = NSTextAlignment.Natural {
		didSet {
			guard horizontalAlignment != oldValue else {
				return
			}

			setNeedsUpdateFinalizedText()
		}
	}


	public var kerning: Kerning? {
		didSet {
			guard kerning != oldValue else {
				return
			}

			invalidateIntrinsicContentSize()
			setNeedsUpdateFinalizedText()
		}
	}


	private var labelLayer: LabelLayer {
		return layer as! LabelLayer
	}


	@warn_unused_result
	public final override class func layerClass() -> AnyObject.Type {
		return LabelLayer.self
	}


	public override func layoutSubviews() {
		super.layoutSubviews()

		textContainer.size = bounds.size.insetBy(padding)

		if finalizedText != lastDrawnFinalizedText {
			setNeedsDisplay()
		}
	}


	public var lineBreakMode = NSLineBreakMode.ByTruncatingTail {
		didSet {
			guard lineBreakMode != oldValue else {
				return
			}

			textContainer.lineBreakMode = lineBreakMode

			invalidateIntrinsicContentSize()
			setNeedsUpdateFinalizedText()
		}
	}


	public var lineHeightMultiple = CGFloat(1) {
		didSet {
			guard lineHeightMultiple != oldValue else {
				return
			}

			invalidateIntrinsicContentSize()
			setNeedsUpdateFinalizedText()
		}
	}


	private func linkAtPoint(point: CGPoint) -> Link? {
		let additionalLinkHitZone = self.additionalLinkHitZone

		var bestLink: Link?
		var bestLinkDistance = CGFloat.infinity

		for link in links {
			for frame in link.frames {
				let hitTestFrame = frame.insetBy(additionalLinkHitZone.inverse)
				guard hitTestFrame.contains(point) else {
					continue
				}

				// distance starts negative from inside the frame and increases the farther the point lies outside
				let distance = frame.distanceTo(point) * (frame.contains(point) ? -1 : 1)
				guard distance < bestLinkDistance else {
					continue
				}

				bestLink = link
				bestLinkDistance = distance
			}
		}

		return bestLink
	}


	private var _links: [Link]?
	private var links: [Link] {
		if let links = _links {
			return links
		}

		let finalizedText = self.finalizedText
		let textContainerOrigin = originForTextContainer()

		var links = [Link]()
		finalizedText.enumerateAttribute(NSLinkAttributeName, inRange: NSRange(forString: finalizedText.string), options: []) { url, range, _ in
			guard let url = url as? NSURL else {
				return
			}

			links.append(Link(range: range, frames: [], url: url))
		}

		links = links.map { link in
			let glyphRange = layoutManager.glyphRangeForCharacterRange(link.range, actualCharacterRange: nil)

			var frames = [CGRect]()
			layoutManager.enumerateEnclosingRectsForGlyphRange(glyphRange, withinSelectedGlyphRange: NSRange(location: NSNotFound, length: 0), inTextContainer: textContainer) { frame, _ in
				frames.append(frame.offsetBy(dx: textContainerOrigin.x, dy: textContainerOrigin.y))
			}

			return Link(range: link.range, frames: frames, url: link.url)
		}

		_links = links
		return links
	}


	public var maximumNumberOfLines: Int? = 1 {
		didSet {
			if let maximumNumberOfLines = maximumNumberOfLines {
				precondition(maximumNumberOfLines > 0, "Label.maximumNumberOfLines must be either larger than zero or nil.")
			}

			guard maximumNumberOfLines != oldValue else {
				return
			}

			textContainer.maximumNumberOfLines = maximumNumberOfLines ?? 0

			invalidateIntrinsicContentSize()
			setNeedsDisplay()
		}
	}


	public var minimumScaleFactor = CGFloat(1) {
		didSet {
			minimumScaleFactor = minimumScaleFactor.clamp(min: 0, max: 1)

			guard minimumScaleFactor != oldValue else {
				return
			}

			invalidateIntrinsicContentSize()
			setNeedsDisplay()
		}
	}


	private var _numberOfLines: Int?
	public var numberOfLines: Int {
		if let numberOfLines = _numberOfLines {
			return numberOfLines
		}

		finalizeText()

		var numberOfLines = 0
		var glyphIndex = 0
		let numberOfGlyphs = layoutManager.numberOfGlyphs

		while (glyphIndex < numberOfGlyphs) {
			var lineRange = NSRange()
			layoutManager.lineFragmentRectForGlyphAtIndex(glyphIndex, effectiveRange: &lineRange)

			glyphIndex = NSMaxRange(lineRange)

			numberOfLines += 1
		}

		_numberOfLines = numberOfLines
		return numberOfLines
	}


	@warn_unused_result
	private func originForTextContainer() -> CGPoint {
		let padding = self.padding
		let bounds = self.bounds

		var textFrame = layoutManager.usedRectForTextContainer(textContainer)

		var textContainerOrigin = CGPoint()
		textContainerOrigin.left = padding.left

		switch verticalAlignment {
		case .Bottom:
			textContainerOrigin.top = bounds.height - padding.bottom - textFrame.height

		case .Center:
			textContainerOrigin.top = padding.top + ((bounds.height - padding.top - padding.bottom - textFrame.height) / 2)

		case .Top:
			textContainerOrigin.top = padding.top
		}

		return textContainerOrigin
	}


	public var padding = UIEdgeInsets.zero {
		didSet {
			guard padding != oldValue else {
				return
			}

			invalidateIntrinsicContentSize()
			setNeedsDisplay()
		}
	}


	public override func pointInside(point: CGPoint, withEvent event: UIEvent?, additionalHitZone: UIEdgeInsets) -> Bool {
		guard super.pointInside(point, withEvent: event, additionalHitZone: additionalHitZone) else {
			return false
		}
		guard userInteractionLimitedToLinks else {
			return true
		}

		return linkAtPoint(point) != nil
	}


	private func setNeedsUpdateFinalizedText() {
		guard _finalizedText != nil else {
			return
		}

		_finalizedText = nil
		_numberOfLines = nil
		setNeedsLayout()
	}


	private func setUpLinkTapRecognizer() {
		let recognizer = linkTapRecognizer
		recognizer.enabled = false
		recognizer.addTarget(self, action: #selector(handleLinkTapRecognizer))

		addGestureRecognizer(recognizer)
	}


	@warn_unused_result
	public override func sizeThatFitsSize(maximumSize: CGSize) -> CGSize {
		let padding = self.padding

		finalizeText()

		let savedTextContainerSize = textContainer.size
		textContainer.size = maximumSize.insetBy(padding)
		defer { textContainer.size = savedTextContainerSize }

		let textSize = alignToGrid(layoutManager.usedRectForTextContainer(textContainer).size)

		return textSize.insetBy(padding.inverse)
	}


	public var text: String {
		get { return attributedText.string }
		set { attributedText = NSAttributedString(string: newValue) }
	}


	public var textColor = UIColor.darkTextColor() {
		didSet {
			guard textColor != oldValue else {
				return
			}

			updateFinalTextColor()
		}
	}


	public override func tintColorDidChange() {
		super.tintColorDidChange()

		updateFinalTextColor()

		if attributedTextUsesTintColor {
			setNeedsUpdateFinalizedText()
		}
	}


	private func updateFinalTextColor() {
		let finalTextColor = textColor.tintedWithColor(tintColor).CGColor
		if finalTextColor != lastUsedFinalTextColor {
			setNeedsUpdateFinalizedText()
		}

		if finalTextColor != labelLayer.finalTextColor {
			labelLayer.finalTextColor = finalTextColor
			setNeedsUpdateFinalizedText()
		}
	}


	public var userInteractionLimitedToLinks = true


	public var verticalAlignment = VerticalAlignment.Center {
		didSet {
			guard verticalAlignment != oldValue else {
				return
			}

			_links = nil
			setNeedsDisplay()
		}
	}


	public override func willResizeToSize(newSize: CGSize) {
		super.willResizeToSize(newSize)

		_numberOfLines = nil
	}



	private final class DelegateProxy: NSObject {

		private unowned var label: Label


		private init(label: Label) {
			self.label = label
		}
	}



	private final class LabelLayer: Layer {

		@objc @NSManaged
		private dynamic var finalTextColor: CGColor


		private override init() {
			super.init()

			finalTextColor = UIColor.darkTextColor().CGColor
		}


		private required init(layer: AnyObject) {
			super.init(layer: layer)
		}


		private required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}


		private override func actionForKey(key: String) -> CAAction? {
			switch key {
			case "finalTextColor":
				if let animation = super.actionForKey("backgroundColor") as? CABasicAnimation {
					animation.fromValue = finalTextColor
					animation.keyPath = key

					return animation
				}

				fallthrough

			default:
				return super.actionForKey(key)
			}
		}


		private override class func needsDisplayForKey(key: String) -> Bool {
			switch key {
			case "finalTextColor": return true
			default: return super.needsDisplayForKey(key)
			}
		}
	}



	private final class LayoutManager: NSLayoutManager {

		@objc(JetPack_linkAttributes)
		private dynamic class var linkAttributes: [NSObject : AnyObject] {
			return [:]
		}


		private override class func initialize() {
			guard self == LayoutManager.self else {
				return
			}

			let defaultLinkAttributesSelector = obfuscatedSelector("_", "default", "Link", "Attributes")
			copyMethodWithSelector(defaultLinkAttributesSelector, fromType: object_getClass(NSLayoutManager.self), toType: object_getClass(self))
			swizzleMethodInType(object_getClass(self), fromSelector: Selector("JetPack_linkAttributes"), toSelector: defaultLinkAttributesSelector)
		}
	}



	private struct Link {

		private var range: NSRange
		private var frames: [CGRect]
		private var url: NSURL
	}



	public enum Kerning: Equatable {

		case Absolute(CGFloat)
		case Relative(CGFloat)
	}
	
	
	
	public enum VerticalAlignment {

		case Bottom
		case Center
		case Top
	}
}


extension Label.DelegateProxy: UIGestureRecognizerDelegate {

	@objc
	private func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
		return label.linkAtPoint(touch.locationInView(label)) != nil
	}
}


public func == (a: Label.Kerning, b: Label.Kerning) -> Bool {
	switch (a, b) {
	case let (.Absolute(a), .Absolute(b)): return a == b
	case let (.Relative(a), .Relative(b)): return a == b
	default:                               return false
	}
}

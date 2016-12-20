import UIKit


@objc(JetPack_Label)
open /* non-final */ class Label: View {

	fileprivate lazy var delegateProxy: DelegateProxy = DelegateProxy(label: self)
	fileprivate lazy var renderingLayer: LabelLayer = self.layer as! LabelLayer

	fileprivate var attributedTextUsesTintColor = false
	fileprivate var cachedSizeThatFits: SizeThatFitsResult?
	fileprivate let layoutManager = LayoutManager()
	fileprivate let linkTapRecognizer = UITapGestureRecognizer()
	fileprivate let textContainer = NSTextContainer()
	fileprivate let textStorage = NSTextStorage()

	open fileprivate(set) var lastDrawnFinalizedText: NSAttributedString?
	open fileprivate(set) var lastUsedFinalTextColor: CGColor?

	open var additionalLinkHitZone = UIEdgeInsets(all: 8) // TODO don't use UIEdgeInsets because actually we outset
	open var linkTapped: ((URL) -> Void)?


	public override init() {
		super.init()

		additionalHitZone = additionalLinkHitZone
		contentMode = .redraw
		isOpaque = false

		layoutManager.addTextContainer(textContainer)
		textStorage.addLayoutManager(layoutManager)

		setUpLinkTapRecognizer()
	}


	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	@NSCopying
	open var attributedText = NSAttributedString() {
		didSet {
			guard attributedText != oldValue else {
				return
			}

			invalidateIntrinsicContentSize()
			setNeedsUpdateFinalizedText()
		}
	}


	open override func didMoveToWindow() {
		super.didMoveToWindow()

		guard let window = window else {
			return
		}

		layer.contentsScale = window.screen.scale
	}


	open override func draw(_ layer: CALayer, in context: CGContext) {
		super.draw(layer, in: context)

		guard let layer = layer as? LabelLayer else {
			return
		}

		let bounds = self.bounds
		guard bounds.size.isPositive else {
			return
		}

		renderingLayer = layer
		lastDrawnFinalizedText = finalizeText()

		UIGraphicsPushContext(context)
		defer { UIGraphicsPopContext() }

		updateTextContainer(forSize: textContainerSize)

		let textContainerOrigin = originForTextContainer()
		let glyphRange = layoutManager.glyphRange(for: textContainer)
		layoutManager.drawBackground(forGlyphRange: glyphRange, at: textContainerOrigin)
		layoutManager.drawGlyphs(forGlyphRange: glyphRange, at: textContainerOrigin)
	}


	open override func draw(_ rect: CGRect) {
		// Although we use drawLayer(_:inContext:) we still need to implement this method.
		// UIKit checks for its presence when it decides whether a call to setNeedsDisplay() is forwarded to its layer.
	}


	open var font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body) {
		didSet {
			guard font != oldValue else {
				return
			}

			invalidateIntrinsicContentSize()
			setNeedsUpdateFinalizedText()
		}
	}


	fileprivate func finalTextColorDidChange() {
		setNeedsUpdateFinalizedText()
	}


	fileprivate func finalizeText() -> NSAttributedString {
		let finalTextColor = renderingLayer.finalTextColor // can change due to animation
		if finalTextColor != lastUsedFinalTextColor {
			lastUsedFinalTextColor = finalTextColor
		}
		else if let finalizedText = _finalizedText {
			return finalizedText
		}

		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = horizontalAlignment
		paragraphStyle.lineBreakMode = .byWordWrapping
		paragraphStyle.lineHeightMultiple = lineHeightMultiple

		var defaultAttributes = [
			NSFontAttributeName: font,
			NSForegroundColorAttributeName: UIColor(cgColor: finalTextColor),
			NSParagraphStyleAttributeName: paragraphStyle
		]

		if let kerning = kerning {
			let kerningValue: CGFloat
			switch kerning {
			case let .absolute(value): kerningValue = value
			case let .relative(value): kerningValue = font.pointSize * value
			}

			defaultAttributes[NSKernAttributeName] = kerningValue as NSObject?
		}

		let attributedText = self.attributedText
		let finalizedText = NSMutableAttributedString(string: attributedText.string, attributes: defaultAttributes)
		finalizedText.beginEditing()

		var attributedTextUsesTintColor = false
		var hasLinks = false
		let tintColor = self.tintColor!

		attributedText.enumerateAttributes(in: NSRange(forString: attributedText.string), options: [.longestEffectiveRangeNotRequired]) { attributes, range, _ in
			var finalAttributes = attributes
			if !hasLinks && attributes[NSLinkAttributeName] != nil {
				hasLinks = true
			}

			if let backgroundColor = attributes[NSBackgroundColorAttributeName] as? UIColor, backgroundColor.tintAlpha != nil {
				finalAttributes[NSBackgroundColorAttributeName] = backgroundColor.tintedWithColor(tintColor)
				attributedTextUsesTintColor = true
			}
			if let foregroundColor = attributes[NSForegroundColorAttributeName] as? UIColor, foregroundColor.tintAlpha != nil {
				finalAttributes[NSForegroundColorAttributeName] = foregroundColor.tintedWithColor(tintColor)
				attributedTextUsesTintColor = true
			}

			finalizedText.addAttributes(finalAttributes, range: range)
		}

		if let textTransform = textTransform {
			let transform: (String) -> String
			switch textTransform {
			case .capitalize: transform = { $0.localizedCapitalized } // TODO this isn't 100% reliable when applying to segments instead of to the whole string
			case .lowercase:  transform = { $0.localizedLowercase }
			case .uppercase:  transform = { $0.localizedUppercase }
			}

			finalizedText.transformStringSegments(transform)
		}

		finalizedText.endEditing()
		textStorage.setAttributedString(finalizedText)
		linkTapRecognizer.isEnabled = hasLinks

		self.attributedTextUsesTintColor = attributedTextUsesTintColor

		_finalizedText = finalizedText
		_links = nil
		_numberOfLines = nil

		return finalizedText
	}


	fileprivate var _finalizedText: NSAttributedString?
	public final var finalizedText: NSAttributedString {
		return finalizeText()
	}


	@objc
	fileprivate func handleLinkTapRecognizer() {
		guard let link = linkAtPoint(linkTapRecognizer.location(in: self)) else {
			return
		}

		linkTapped?(link.url)
	}


	open var horizontalAlignment = NSTextAlignment.natural {
		didSet {
			guard horizontalAlignment != oldValue else {
				return
			}

			setNeedsUpdateFinalizedText()
		}
	}


	open override func invalidateIntrinsicContentSize() {
		cachedSizeThatFits = nil

		super.invalidateIntrinsicContentSize()
	}


	open var kerning: Kerning? {
		didSet {
			guard kerning != oldValue else {
				return
			}

			invalidateIntrinsicContentSize()
			setNeedsUpdateFinalizedText()
		}
	}


	fileprivate var labelLayer: LabelLayer {
		return layer as! LabelLayer
	}


	
	public final override class var layerClass : AnyObject.Type {
		return LabelLayer.self
	}


	open override func layoutSubviews() {
		super.layoutSubviews()

		if finalizedText != lastDrawnFinalizedText {
			setNeedsDisplay()
		}
	}


	open var lineBreakMode = NSLineBreakMode.byTruncatingTail {
		didSet {
			guard lineBreakMode != oldValue else {
				return
			}

			invalidateIntrinsicContentSize()
			setNeedsUpdateFinalizedText()
		}
	}


	open var lineHeightMultiple = CGFloat(1) {
		didSet {
			guard lineHeightMultiple != oldValue else {
				return
			}

			invalidateIntrinsicContentSize()
			setNeedsUpdateFinalizedText()
		}
	}


	fileprivate func linkAtPoint(_ point: CGPoint) -> Link? {
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


	fileprivate var _links: [Link]?
	fileprivate var links: [Link] {
		if let links = _links {
			return links
		}

		updateTextContainer(forSize: textContainerSize)

		let finalizedText = self.finalizedText
		let textContainerOrigin = originForTextContainer()

		var links = [Link]()
		finalizedText.enumerateAttribute(NSLinkAttributeName, in: NSRange(forString: finalizedText.string), options: []) { url, range, _ in
			guard let url = url as? URL else {
				return
			}

			links.append(Link(range: range, frames: [], url: url))
		}

		links = links.map { link in
			let glyphRange = layoutManager.glyphRange(forCharacterRange: link.range, actualCharacterRange: nil)

			var frames = [CGRect]()
			layoutManager.enumerateEnclosingRects(forGlyphRange: glyphRange, withinSelectedGlyphRange: NSRange(location: NSNotFound, length: 0), in: textContainer) { frame, _ in
				frames.append(frame.offsetBy(dx: textContainerOrigin.x, dy: textContainerOrigin.y))
			}

			return Link(range: link.range, frames: frames, url: link.url)
		}

		_links = links
		return links
	}


	open var maximumNumberOfLines: Int? = 1 {
		didSet {
			if let maximumNumberOfLines = maximumNumberOfLines {
				precondition(maximumNumberOfLines > 0, "Label.maximumNumberOfLines must be either larger than zero or nil.")
			}

			guard maximumNumberOfLines != oldValue else {
				return
			}

			invalidateIntrinsicContentSize()
			setNeedsDisplay()
		}
	}


	open var minimumScaleFactor = CGFloat(1) {
		didSet {
			minimumScaleFactor = minimumScaleFactor.coerced(in: 0 ... 1)

			guard minimumScaleFactor != oldValue else {
				return
			}

			invalidateIntrinsicContentSize()
			setNeedsDisplay()
		}
	}


	fileprivate var _numberOfLines: Int?
	open var numberOfLines: Int {
		if let numberOfLines = _numberOfLines {
			return numberOfLines
		}

		finalizeText()

		var numberOfLines = 0
		var glyphIndex = 0
		let numberOfGlyphs = layoutManager.numberOfGlyphs

		while (glyphIndex < numberOfGlyphs) {
			var lineRange = NSRange()
			layoutManager.lineFragmentRect(forGlyphAt: glyphIndex, effectiveRange: &lineRange)

			glyphIndex = NSMaxRange(lineRange)

			numberOfLines += 1
		}

		_numberOfLines = numberOfLines
		return numberOfLines
	}


	
	fileprivate func originForTextContainer() -> CGPoint {
		let padding = self.padding
		let bounds = self.bounds

		var textFrame = layoutManager.usedRect(for: textContainer)

		var textContainerOrigin = CGPoint()
		textContainerOrigin.left = padding.left

		switch verticalAlignment {
		case .bottom:
			textContainerOrigin.top = bounds.height - padding.bottom - textFrame.height

		case .center:
			textContainerOrigin.top = padding.top + ((bounds.height - padding.top - padding.bottom - textFrame.height) / 2)

		case .top:
			textContainerOrigin.top = padding.top
		}

		return textContainerOrigin
	}


	open var padding = UIEdgeInsets.zero {
		didSet {
			guard padding != oldValue else {
				return
			}

			invalidateIntrinsicContentSize()
			setNeedsDisplay()
		}
	}


	open override func pointInside(_ point: CGPoint, withEvent event: UIEvent?, additionalHitZone: UIEdgeInsets) -> Bool {
		guard super.pointInside(point, withEvent: event, additionalHitZone: additionalHitZone) else {
			return false
		}
		guard userInteractionLimitedToLinks else {
			return true
		}

		return linkAtPoint(point) != nil
	}


	fileprivate func setNeedsUpdateFinalizedText() {
		guard _finalizedText != nil else {
			return
		}

		_finalizedText = nil
		_numberOfLines = nil
		setNeedsLayout()
	}


	fileprivate func setUpLinkTapRecognizer() {
		let recognizer = linkTapRecognizer
		recognizer.isEnabled = false
		recognizer.addTarget(self, action: #selector(handleLinkTapRecognizer))

		addGestureRecognizer(recognizer)
	}


	
	open override func sizeThatFitsSize(_ maximumSize: CGSize) -> CGSize {
		assert(maximumSize.isPositive)

		let maximumSize = maximumSize.coerced(atLeast: .zero)
		if maximumSize.isPositive, let cachedSizeThatFits = cachedSizeThatFits {
			let cachedMaximumHeights = min(cachedSizeThatFits.maximumSize.height, cachedSizeThatFits.sizeThatFits.height) ... max(cachedSizeThatFits.maximumSize.height, cachedSizeThatFits.sizeThatFits.height)
			let cachedMaximumWidths = min(cachedSizeThatFits.maximumSize.width, cachedSizeThatFits.sizeThatFits.width) ... max(cachedSizeThatFits.maximumSize.width, cachedSizeThatFits.sizeThatFits.width)

			if cachedMaximumWidths.contains(maximumSize.width) && cachedMaximumHeights.contains(maximumSize.height) {
				return cachedSizeThatFits.sizeThatFits
			}
		}

		let padding = self.padding

		updateTextContainer(forSize: maximumSize.insetBy(padding))

		let textSize = alignToGrid(layoutManager.usedRect(for: textContainer).size)

		let sizeThatFits = textSize.insetBy(padding.inverse)
		cachedSizeThatFits = SizeThatFitsResult(maximumSize: maximumSize, sizeThatFits: sizeThatFits)

		return sizeThatFits
	}


	open var text: String {
		get { return attributedText.string }
		set { attributedText = NSAttributedString(string: newValue) }
	}


	open var textColor = UIColor.darkText {
		didSet {
			guard textColor != oldValue else {
				return
			}

			updateFinalTextColor()
		}
	}


	fileprivate var textContainerSize: CGSize {
		return bounds.size.insetBy(padding)
	}


	open var textTransform: TextTransform? {
		didSet {
			guard textTransform != oldValue else {
				return
			}

			setNeedsUpdateFinalizedText()
		}
	}


	open override func tintColorDidChange() {
		super.tintColorDidChange()

		updateFinalTextColor()

		if attributedTextUsesTintColor {
			setNeedsUpdateFinalizedText()
		}
	}


	fileprivate func updateFinalTextColor() {
		let finalTextColor = textColor.tintedWithColor(tintColor).cgColor
		if finalTextColor != lastUsedFinalTextColor {
			setNeedsUpdateFinalizedText()
		}

		if finalTextColor != labelLayer.finalTextColor {
			labelLayer.finalTextColor = finalTextColor
			setNeedsUpdateFinalizedText()
		}
	}


	fileprivate func updateTextContainer(forSize size: CGSize) {
		textContainer.lineFragmentPadding = 0
		textContainer.maximumNumberOfLines = maximumNumberOfLines ?? 0
		textContainer.lineBreakMode = lineBreakMode
		textContainer.size = size
		textStorage.setAttributedString(finalizeText())
	}


	open var userInteractionLimitedToLinks = true


	open var verticalAlignment = VerticalAlignment.center {
		didSet {
			guard verticalAlignment != oldValue else {
				return
			}

			_links = nil
			setNeedsDisplay()
		}
	}


	open override func willResizeToSize(_ newSize: CGSize) {
		super.willResizeToSize(newSize)

		_numberOfLines = nil
	}



	fileprivate final class DelegateProxy: NSObject {

		fileprivate unowned var label: Label


		fileprivate init(label: Label) {
			self.label = label
		}
	}



	fileprivate final class LabelLayer: Layer {

		@objc @NSManaged
		fileprivate dynamic var finalTextColor: CGColor


		fileprivate override init() {
			super.init()

			finalTextColor = UIColor.darkText.cgColor
		}


		fileprivate required init(layer: Any) {
			super.init(layer: layer)
		}


		fileprivate required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}


		fileprivate override func action(forKey key: String) -> CAAction? {
			switch key {
			case "finalTextColor":
				if let animation = super.action(forKey: "backgroundColor") as? CABasicAnimation {
					animation.fromValue = finalTextColor
					animation.keyPath = key

					return animation
				}

				fallthrough

			default:
				return super.action(forKey: key)
			}
		}


		fileprivate override class func needsDisplay(forKey key: String) -> Bool {
			switch key {
			case "finalTextColor": return true
			default: return super.needsDisplay(forKey: key)
			}
		}
	}



	fileprivate final class LayoutManager: NSLayoutManager {

		@objc(JetPack_linkAttributes)
		fileprivate dynamic class var linkAttributes: [AnyHashable: Any] {
			return [:]
		}


		fileprivate override class func initialize() {
			guard self == LayoutManager.self else {
				return
			}

			let defaultLinkAttributesSelector = obfuscatedSelector("_", "default", "Link", "Attributes")
			copyMethodWithSelector(defaultLinkAttributesSelector, fromType: object_getClass(NSLayoutManager.self), toType: object_getClass(self))
			swizzleMethodInType(object_getClass(self), fromSelector: Selector("JetPack_linkAttributes"), toSelector: defaultLinkAttributesSelector)
		}
	}



	fileprivate struct Link {

		fileprivate var range: NSRange
		fileprivate var frames: [CGRect]
		fileprivate var url: URL
	}



	public enum Kerning: Equatable {

		case absolute(CGFloat)
		case relative(CGFloat)
	}



	fileprivate struct SizeThatFitsResult {

		fileprivate var maximumSize: CGSize
		fileprivate var sizeThatFits: CGSize
	}



	public enum TextTransform {

		case capitalize
		case lowercase
		case uppercase
	}
	
	
	
	public enum VerticalAlignment {

		case bottom
		case center
		case top
	}
}


extension Label.DelegateProxy: UIGestureRecognizerDelegate {

	@objc
	fileprivate func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		return label.linkAtPoint(touch.location(in: label)) != nil
	}
}


public func == (a: Label.Kerning, b: Label.Kerning) -> Bool {
	switch (a, b) {
	case let (.absolute(a), .absolute(b)): return a == b
	case let (.relative(a), .relative(b)): return a == b
	default:                               return false
	}
}

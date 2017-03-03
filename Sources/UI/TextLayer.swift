import UIKit


internal class TextLayer: Layer, NSLayoutManagerDelegate {

	private var attributedTextUsesTintColor = false
	private var cachedSizeThatFits: SizeThatFitsResult?
	private var capitalLetterSpacing: NSAttributedString.CapitalLetterSpacing
	private var lastDrawnFinalizedText: NSAttributedString?
	private var lastUsedFinalTextColor: CGColor?
	private let layoutManager: LayoutManager
	private let textContainer: NSTextContainer
	private let textStorage: NSTextStorage

	@objc @NSManaged
	private dynamic var finalTextColor: CGColor


	internal override init() {
		capitalLetterSpacing = NSAttributedString.CapitalLetterSpacing(above: 0, below: 0)
		layoutManager = LayoutManager()
		textContainer = NSTextContainer()
		textStorage = NSTextStorage()

		super.init()

		finalTextColor = UIColor.darkText.cgColor
		isOpaque = false
		layoutManager.delegate = self
		layoutManager.addTextContainer(textContainer)
		textStorage.addLayoutManager(layoutManager)
	}


	internal required init(layer: Any) {
		let layer = layer as! TextLayer
		capitalLetterSpacing = layer.capitalLetterSpacing
		layoutManager = layer.layoutManager
		textContainer = layer.textContainer
		textStorage = layer.textStorage

		super.init(layer: layer)

		finalTextColor = layer.finalTextColor

		// FIXME
		fatalError()
	}


	internal required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	internal override func action(forKey key: String) -> CAAction? {
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


	open var additionalLinkHitZone = UIEdgeInsets(all: 8) // TODO don't use UIEdgeInsets because actually we outset


	@NSCopying
	internal var attributedText = NSAttributedString() {
		didSet {
			guard attributedText != oldValue else {
				return
			}

			invalidateSizeThatFits()
			setNeedsUpdateFinalizedText()
		}
	}


	internal override func draw(in context: CGContext) {
		log("Drawing: \(self)") // FIXME
		super.draw(in: context)

		let bounds = self.bounds
		guard bounds.size.isPositive else {
			return
		}

		lastDrawnFinalizedText = finalizeText()

		UIGraphicsPushContext(context)
		defer { UIGraphicsPopContext() }

		updateTextContainer(forSize: textContainerSize)

		let textContainerOrigin = originForTextContainer()
		let glyphRange = layoutManager.glyphRange(for: textContainer)
		layoutManager.drawBackground(forGlyphRange: glyphRange, at: textContainerOrigin)
		layoutManager.drawGlyphs(forGlyphRange: glyphRange, at: textContainerOrigin)
	}


	private func finalTextColorDidChange() {
		setNeedsUpdateFinalizedText()
	}


	@discardableResult
	private func finalizeText() -> NSAttributedString {
		let finalTextColor = self.finalTextColor // can change due to animation
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
			case let .absolute(value):           kerningValue = value
			case let .relativeToFontSize(value): kerningValue = font.pointSize * value // TODO font may vary in attributed strings
			}

			defaultAttributes[NSKernAttributeName] = kerningValue as NSObject?
		}

		let attributedText = self.attributedText
		let finalizedText = NSMutableAttributedString(string: attributedText.string, attributes: defaultAttributes)
		finalizedText.beginEditing()

		var attributedTextUsesTintColor = false
		var hasLinks = false
		let tintColor = self.tintColor

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


		// layoutManager's bounding rectangle won't be calculated correctly unless we tell it to do so…
		for glyphIndex in 0 ..< layoutManager.numberOfGlyphs {
			layoutManager.setDrawsOutsideLineFragment(true, forGlyphAt: glyphIndex)
		}

		self.attributedTextUsesTintColor = attributedTextUsesTintColor

		_finalizedText = finalizedText
		_links = nil
		_numberOfLines = nil
		
		return finalizedText
	}


	private var _finalizedText: NSAttributedString?
	internal final var finalizedText: NSAttributedString {
		return finalizeText()
	}


	internal var font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body) {
		didSet {
			guard font != oldValue else {
				return
			}

			invalidateSizeThatFits()
			setNeedsUpdateFinalizedText()
		}
	}


	internal var horizontalAlignment = TextAlignment.Horizontal.natural {
		didSet {
			guard horizontalAlignment != oldValue else {
				return
			}

			invalidateSizeThatFits()
			setNeedsUpdateFinalizedText()
		}
	}


	internal var kerning: TextKerning? {
		didSet {
			guard kerning != oldValue else {
				return
			}

			invalidateSizeThatFits()
			setNeedsUpdateFinalizedText()
		}
	}


	private func invalidateSizeThatFits() {
		cachedSizeThatFits = nil
	}


	// FIXME
	internal func layoutManager(_ layoutManager: NSLayoutManager, shouldSetLineFragmentRect lineFragmentRect: UnsafeMutablePointer<CGRect>, lineFragmentUsedRect: UnsafeMutablePointer<CGRect>, baselineOffset: UnsafeMutablePointer<CGFloat>, in textContainer: NSTextContainer, forGlyphRange glyphRange: NSRange) -> Bool {
		let isFirstLine = (glyphRange.location == 0)
		let isLastLine = (glyphRange.location + glyphRange.length >= layoutManager.numberOfGlyphs)

		if isFirstLine || isLastLine, let textStorage = layoutManager.textStorage {
			let characterRange = layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
			if let capitalLetterSpacing = textStorage.capitalLetterSpacing(in: characterRange, forLineHeight: lineFragmentUsedRect.pointee.height) {
				self.capitalLetterSpacing = capitalLetterSpacing
			}
		}

		print("lineFragmentRect = \(lineFragmentRect.pointee), lineFragmentUsedRect = \(lineFragmentUsedRect.pointee), baselineOffset = \(baselineOffset.pointee), glyphRange = \(glyphRange)")
		return true
	}


	internal override func layoutSublayers() {
		super.layoutSublayers()

		if finalizedText != lastDrawnFinalizedText {
			setNeedsDisplay()
		}
	}


	internal var lineBreakMode = NSLineBreakMode.byTruncatingTail {
		didSet {
			guard lineBreakMode != oldValue else {
				return
			}

			invalidateSizeThatFits()
			setNeedsUpdateFinalizedText()
		}
	}


	internal var lineHeightMultiple = CGFloat(1) {
		didSet {
			guard lineHeightMultiple != oldValue else {
				return
			}

			invalidateSizeThatFits()
			setNeedsUpdateFinalizedText()
		}
	}


	internal func link(at point: CGPoint) -> Link? {
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
				let distance = frame.distance(to: point) * (frame.contains(point) ? -1 : 1)
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


	internal var maximumNumberOfLines: Int? = 1 {
		didSet {
			if let maximumNumberOfLines = maximumNumberOfLines {
				precondition(maximumNumberOfLines > 0, "Label.maximumNumberOfLines must be either larger than zero or nil.")
			}

			guard maximumNumberOfLines != oldValue else {
				return
			}

			invalidateSizeThatFits()
			setNeedsDisplay()
		}
	}


	internal var minimumScaleFactor = CGFloat(1) {
		didSet {
			minimumScaleFactor = minimumScaleFactor.coerced(in: 0 ... 1)

			guard minimumScaleFactor != oldValue else {
				return
			}

			invalidateSizeThatFits()
			setNeedsDisplay()
		}
	}


	internal override class func needsDisplay(forKey key: String) -> Bool {
		switch key {
		case "finalTextColor": return true
		default: return super.needsDisplay(forKey: key)
		}
	}


	private var _numberOfLines: Int?
	internal var numberOfLines: Int {
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

			invalidateSizeThatFits()
			setNeedsDisplay()
		}
	}


	private func setNeedsUpdateFinalizedText() {
		guard _finalizedText != nil else {
			return
		}

		_finalizedText = nil
		_numberOfLines = nil
		setNeedsLayout()
	}


	// FIXME
	internal override func size(thatFits maximumSize: CGSize) -> CGSize {
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

		CONTINUE HERE!
		// bounding rect vs. inner rect so that the superlayer knows how to lay out this layer 
		print("usedRect = \(layoutManager.usedRect(for: textContainer))")
		print("boundingRect = \(layoutManager.boundingRect(forGlyphRange: NSRange(location:0, length:layoutManager.numberOfGlyphs), in: textContainer))")
		print("out = \(layoutManager.drawsOutsideLineFragment(forGlyphAt: 0))")

		layoutManager.enumerateEnclosingRects(forGlyphRange: NSRange(location: 0, length: layoutManager.numberOfGlyphs), withinSelectedGlyphRange: NSRange(location: NSNotFound, length: 0), in: textContainer) { (a, _) in
			print("\(a)")
		}

		let textSize = layoutManager.usedRect(for: textContainer).size

		let sizeThatFits = textSize.insetBy(padding.inverse)
		cachedSizeThatFits = SizeThatFitsResult(maximumSize: maximumSize, sizeThatFits: sizeThatFits)

		return sizeThatFits
	}


	internal var text: String {
		get { return attributedText.string }
		set { attributedText = NSAttributedString(string: newValue) }
	}


	internal var textColor = UIColor.darkText {
		didSet {
			guard textColor != oldValue else {
				return
			}

			updateFinalTextColor()
		}
	}


	private var textContainerSize: CGSize {
		return bounds.size.insetBy(padding)
	}


	internal var textTransform: TextTransform? {
		didSet {
			guard textTransform != oldValue else {
				return
			}

			invalidateSizeThatFits()
			setNeedsUpdateFinalizedText()
		}
	}


	internal var tintColor = UIColor.red {
		didSet {
			guard tintColor != oldValue else {
				return
			}

			updateFinalTextColor()

			if attributedTextUsesTintColor {
				setNeedsUpdateFinalizedText()
			}
		}
	}


	private func updateFinalTextColor() {
		let finalTextColor = textColor.tintedWithColor(tintColor).cgColor
		if finalTextColor != lastUsedFinalTextColor {
			setNeedsUpdateFinalizedText()
		}

		if finalTextColor != self.finalTextColor {
			self.finalTextColor = finalTextColor
			setNeedsUpdateFinalizedText()
		}
	}


	private func updateTextContainer(forSize size: CGSize) {
		textContainer.lineFragmentPadding = 0
		textContainer.maximumNumberOfLines = maximumNumberOfLines ?? 0
		textContainer.lineBreakMode = lineBreakMode
		textContainer.size = size

		finalizeText()
	}


	open var verticalAlignment = TextAlignment.Vertical.center {
		didSet {
			guard verticalAlignment != oldValue else {
				return
			}

			_links = nil
			setNeedsDisplay()
		}
	}


	internal override func willResizeToSize(_ newSize: CGSize) {
		super.willResizeToSize(newSize)

		_numberOfLines = nil
	}



	private final class LayoutManager: NSLayoutManager {

		@objc(JetPack_linkAttributes)
		private dynamic class var linkAttributes: [AnyHashable: Any] {
			return [:]
		}


		fileprivate override class func initialize() {
			guard self == LayoutManager.self else {
				return
			}

			let defaultLinkAttributesSelector = obfuscatedSelector("_", "default", "Link", "Attributes")
			copyMethod(selector: defaultLinkAttributesSelector, from: object_getClass(NSLayoutManager.self), to: object_getClass(self))
			swizzleMethod(in: object_getClass(self), from: #selector(getter: LayoutManager.linkAttributes), to: defaultLinkAttributesSelector)
		}
	}



	internal struct Link {

		internal var range: NSRange
		internal var frames: [CGRect]
		internal var url: URL
	}



	private struct SizeThatFitsResult {

		var maximumSize: CGSize
		var sizeThatFits: CGSize
	}
}

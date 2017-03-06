import UIKit


internal class TextLayer: Layer {

	private var configuration = Configuration()
	private var textLayout: TextLayout?


	internal override init() {
		super.init()

		backgroundColor = UIColor.red.withAlphaComponent(0.25).cgColor
		isOpaque = false
		textColor = UIColor.darkText
	}


	internal required init(layer: Any) {
		let layer = layer as! TextLayer
		configuration = layer.configuration
		textLayout = layer.textLayout

		super.init(layer: layer)
	}


	internal required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	internal override func action(forKey key: String) -> CAAction? {
		switch key {
		case "textColor":
			if let animation = super.action(forKey: "backgroundColor") as? CABasicAnimation {
				animation.fromValue = textColor
				animation.keyPath = key

				return animation
			}

			fallthrough

		default:
			return super.action(forKey: key)
		}
	}


	internal var attributedText: NSAttributedString {
		get { return configuration.text }
		set {
			configuration.text = newValue
			checkConfiguration()
		}
	}


	private func buildTextLayoutIfNecessary() -> TextLayout {
		if let textLayout = self.textLayout {
			return textLayout
		}

		let textLayout = TextLayout.cache.getOrCreate(forText: configuration.finalText, maximumSize: textSize, maximumNumberOfLines: maximumNumberOfLines)

		self.textLayout = textLayout
		return textLayout
	}


	private func checkConfiguration() {
		if configuration.needsRebuildFinalText {
			invalidateTextLayout()
		}
	}


	internal override func draw(in context: CGContext) {
		log("Drawing: \(self)") // FIXME
		super.draw(in: context)

		buildTextLayoutIfNecessary().draw(in: context, textColor: textColor, tintColor: tintColor)
	}


	internal var drawingOverflow: UIEdgeInsets {
		return buildTextLayoutIfNecessary().drawingOverflow
	}


	internal var font: UIFont {
		get { return configuration.font }
		set {
			configuration.font = newValue
			checkConfiguration()
		}
	}


	internal var horizontalAlignment: TextAlignment.Horizontal {
		get { return configuration.horizontalAlignment }
		set {
			configuration.horizontalAlignment = newValue
			checkConfiguration()
		}
	}


	internal var kerning: TextKerning? {
		get { return configuration.kerning }
		set {
			configuration.kerning = newValue
			checkConfiguration()
		}
	}


	private func invalidateTextLayout() {
		textLayout = nil
		setNeedsDisplay()
	}


	internal override func layoutSublayers() {
		super.layoutSublayers()

		// FIXME
	}


	internal var lineBreakMode: NSLineBreakMode {
		get { return configuration.lineBreakMode }
		set {
			configuration.lineBreakMode = newValue
			checkConfiguration()
		}
	}


	internal var lineHeightMultiple: CGFloat {
		get { return configuration.lineHeightMultiple }
		set {
			configuration.lineHeightMultiple = newValue
			checkConfiguration()
		}
	}


	internal var maximumNumberOfLines: Int? {
		get { return configuration.maximumNumberOfLines }
		set {
			configuration.maximumNumberOfLines = newValue
			checkConfiguration()
		}
	}


	// FIXME
	/*
	internal var minimumScaleFactor = CGFloat(1) {
		didSet {
			minimumScaleFactor = minimumScaleFactor.coerced(in: 0 ... 1)

			guard minimumScaleFactor != oldValue else {
				return
			}

			invalidateSizeThatFits()
			setNeedsDisplay()
		}
	}*/


	internal override class func needsDisplay(forKey key: String) -> Bool {
		switch key {
		case "textColor": return true
		default:          return super.needsDisplay(forKey: key)
		}
	}

/*
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
*/


	// FIXME
	internal func textSize(thatFits maximumSize: CGSize) -> CGSize {
		assert(maximumSize.isPositive)

		let layout = TextLayout.cache.getOrCreate(forText: configuration.finalText, maximumSize: maximumSize, maximumNumberOfLines: maximumNumberOfLines)
		return layout.measuredSize
	}


	internal var text: String {
		get { return attributedText.string }
		set { attributedText = NSAttributedString(string: newValue) }
	}


	internal var textSize = CGSize.zero {
		didSet {
			guard textSize != oldValue else {
				return
			}

			invalidateTextLayout()
		}
	}


	@objc @NSManaged
	internal dynamic var textColor: UIColor


	internal var textTransform: TextTransform? {
		get { return configuration.textTransform }
		set {
			configuration.textTransform = newValue
			checkConfiguration()
		}
	}


	// FIXME copy? configuration?
	internal var tintColor = UIColor.red {
		didSet {
			guard tintColor != oldValue else {
				return
			}

			// FIXME only if necessary
			setNeedsDisplay()
		}
	}


	internal override func willResizeToSize(_ newSize: CGSize) {
		super.willResizeToSize(newSize)

		invalidateTextLayout()
	}



	private struct Configuration {

		private var _finalText: NSAttributedString?


		var finalText: NSAttributedString {
			mutating get {
				if let finalText = _finalText {
					return finalText
				}

				let paragraphStyle = NSMutableParagraphStyle()
				paragraphStyle.alignment = horizontalAlignment
				paragraphStyle.lineHeightMultiple = lineHeightMultiple

				let finalText = text.withDefaultAttributes(
					font:            font,
					kerning:         kerning,
					paragraphStyle:  paragraphStyle,
					transform:       textTransform
				)

				_finalText = finalText
				return finalText
			}
		}


		var font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body) {
			didSet {
				if font != oldValue {
					_finalText = nil
				}
			}
		}


		var horizontalAlignment = TextAlignment.Horizontal.natural {
			didSet {
				if horizontalAlignment != oldValue {
					_finalText = nil
				}
			}
		}


		var kerning: TextKerning? {
			didSet {
				if kerning != oldValue {
					_finalText = nil
				}
			}
		}


		var lineBreakMode = NSLineBreakMode.byWordWrapping {
			didSet {
				if lineBreakMode != oldValue {
					_finalText = nil
				}
			}
		}


		var lineHeightMultiple = CGFloat(1) {
			didSet {
				precondition(lineHeightMultiple > 0, ".lineHeightMultiple must be > 0")

				if lineHeightMultiple != oldValue {
					_finalText = nil
				}
			}
		}


		var maximumNumberOfLines: Int? = 1 {
			didSet {
				if let maximumNumberOfLines = maximumNumberOfLines {
					precondition(maximumNumberOfLines > 0, ".maximumNumberOfLines must be > 0")
				}
			}
		}


		var needsRebuildFinalText: Bool {
			return _finalText == nil
		}


		var text = NSAttributedString() {
			didSet {
				if text != oldValue {
					_finalText = nil
				}
			}
		}


		var textTransform: TextTransform? {
			didSet {
				if textTransform != oldValue {
					_finalText = nil
				}
			}
		}
	}



	internal struct Link {

		internal var range: NSRange
		internal var frames: [CGRect]
		internal var url: URL
	}



	private class TextLayout: NSObject, NSLayoutManagerDelegate {

		static var cache = Cache()

		private var drawingOrigin = CGPoint.zero
		private var drawingTextColor = UIColor.red
		private var drawingTintColor = UIColor.red
		private var isTruncated = false
		private let layoutManager = LayoutManager()
		private let maximumNumberOfLines: Int?
		private let maximumSize: CGSize
		private var numberOfLines = 0
		private let textContainer = NSTextContainer()
		private let textStorage = NSTextStorage()

		private(set) var drawingOverflow = UIEdgeInsets.zero
		private(set) var measuredSize = CGSize.zero

		let text: NSAttributedString


		init(text: NSAttributedString, maximumSize: CGSize, maximumNumberOfLines: Int?) {
			precondition(maximumSize.isPositive)

			if let maximumNumberOfLines = maximumNumberOfLines {
				precondition(maximumNumberOfLines > 0)
			}

			self.maximumNumberOfLines = maximumNumberOfLines
			self.maximumSize = maximumSize
			self.text = text

			super.init()

			layoutManager.delegate = self
			layoutManager.usesFontLeading = true
			layoutManager.addTextContainer(textContainer)

			textContainer.lineFragmentPadding = 0
			textContainer.maximumNumberOfLines = maximumNumberOfLines ?? 0
			//textContainer.lineBreakMode = configuration.lineBreakMode
			textContainer.size = maximumSize // FIXME

			textStorage.addLayoutManager(layoutManager)
			textStorage.setAttributedString(text)

			guard let visibleGlyphRange = layoutManager.glyphRange(for: textContainer).toCountableRange() else {
				return
			}

			// layoutManager's bounding rectangle won't be calculated correctly unless we tell it to do so…
			for glyphIndex in visibleGlyphRange {
				layoutManager.setDrawsOutsideLineFragment(true, forGlyphAt: glyphIndex)
			}

			var capitalLetterSpacingAboveFirstLine = CGFloat(0)
			var capitalLetterSpacingBelowLastLine = CGFloat(0)
			var minimumBoundingBoxLeft = CGFloat(0)
			var minimumBoundingBoxTop = CGFloat(0)
			var maximumBoundingBoxWidth = CGFloat(0)
			var maximumBoundingBoxHeight = CGFloat(0)
			var numberOfLines = 0
			let newlineCharacterSet = CharacterSet.newlines

			layoutManager.enumerateLineFragments(forGlyphRange: visibleGlyphRange.toNSRange()) { rect, usedRect, _, lineRange, _ in
				let lineRange = lineRange.toCountableRange()!
				let isFirstLine = (lineRange.lowerBound == visibleGlyphRange.lowerBound)
				let isLastLine = (lineRange.upperBound >= visibleGlyphRange.upperBound)

				let characterRange = self.layoutManager.characterRange(forGlyphRange: lineRange.toNSRange(), actualGlyphRange: nil)
				if let capitalLetterSpacing = self.textStorage.capitalLetterSpacing(in: characterRange, forLineHeight: usedRect.height, usingFontLeading: self.layoutManager.usesFontLeading) {
					if isFirstLine {
						capitalLetterSpacingAboveFirstLine = capitalLetterSpacing.above
					}
					if isLastLine {
						capitalLetterSpacingBelowLastLine = capitalLetterSpacing.below
					}
				}

				let string = self.textStorage.string
				var glyphRangeForBoundingRect = lineRange.toNSRange()
				if glyphRangeForBoundingRect.length > 0, let characterRange = characterRange.rangeInString(string), let lastCharacter = string[characterRange].unicodeScalars.last, newlineCharacterSet.contains(lastCharacter) {
					// boundingRect is unreliable when the range ends with a newline character, so we'll exclude it
					glyphRangeForBoundingRect.length -= 1
				}

				let boundingRect = self.layoutManager.boundingRect(forGlyphRange: glyphRangeForBoundingRect, in: self.textContainer)
				minimumBoundingBoxLeft = min(minimumBoundingBoxLeft, boundingRect.left)
				minimumBoundingBoxTop = min(minimumBoundingBoxTop, boundingRect.top)
				maximumBoundingBoxWidth = max(maximumBoundingBoxWidth, boundingRect.width)
				maximumBoundingBoxHeight = max(maximumBoundingBoxHeight, boundingRect.height)

				numberOfLines += 1
			}

			var boundingRect = CGRect(left: minimumBoundingBoxLeft, top: minimumBoundingBoxTop, width: maximumBoundingBoxWidth, height: maximumBoundingBoxHeight)

			var measuredSize = layoutManager.usedRect(for: textContainer).size
			measuredSize.height -= (capitalLetterSpacingAboveFirstLine * 2).rounded() / 2 // FIXME
			measuredSize.height -= (capitalLetterSpacingBelowLastLine * 2).rounded() / 2 // FIXME
			measuredSize.width = (measuredSize.width * 2).rounded(.up) / 2 // FIXME
			measuredSize.height = (measuredSize.height * 2).rounded(.up) / 2 // FIXME

			let measuredRect = CGRect(left: 0, top: 0, width: measuredSize.width, height: measuredSize.height)
			boundingRect.left = (boundingRect.left * 2).rounded(.down) / 2 // FIXME
			boundingRect.top = (boundingRect.top * 2).rounded(.down) / 2 // FIXME
			boundingRect.width = (boundingRect.width * 2).rounded(.up) / 2 // FIXME
			boundingRect.height = (boundingRect.height * 2).rounded(.up) / 2 // FIXME
			var drawingOverflow = UIEdgeInsets(fromRect: measuredRect, toRect: boundingRect)
			drawingOverflow.top -= ((capitalLetterSpacingAboveFirstLine * 2).rounded() / 2) // FIXME

			self.drawingOrigin = CGRect(size: measuredSize).insetBy(drawingOverflow.inverse).origin.offsetBy(dx: 0, dy: -((capitalLetterSpacingAboveFirstLine * 2).rounded() / 2)) // FIXME
			self.drawingOverflow = drawingOverflow
			self.isTruncated = visibleGlyphRange.upperBound >= layoutManager.numberOfGlyphs // FIXME may not account for ellipsis replacing single character
			self.measuredSize = measuredSize
			self.numberOfLines = numberOfLines
		}


		func draw(in context: CGContext, textColor: UIColor, tintColor: UIColor) {
			UIGraphicsPushContext(context)
			defer { UIGraphicsPopContext() }

			drawingTextColor = textColor.tintedWithColor(tintColor)
			drawingTintColor = tintColor

			let glyphRange = layoutManager.glyphRange(for: textContainer)
			layoutManager.drawBackground(forGlyphRange: glyphRange, at: drawingOrigin)
			layoutManager.drawGlyphs(forGlyphRange: glyphRange, at: drawingOrigin)
		}


		func isValidFor(maximumSize: CGSize, maximumNumberOfLines: Int?) -> Bool {
			let cachedHeights = min(self.maximumSize.height, measuredSize.height) ... max(self.maximumSize.height, measuredSize.height)
			let cachedWidths = min(self.maximumSize.width, measuredSize.width) ... max(self.maximumSize.width, measuredSize.width)
			guard cachedHeights.contains(maximumSize.height) && cachedWidths.contains(maximumSize.width) else {
				return false
			}

			if let maximumNumberOfLines = maximumNumberOfLines {
				guard numberOfLines <= maximumNumberOfLines else {
					return false
				}
				if isTruncated, let ownMaximumNumberOfLines = self.maximumNumberOfLines {
					guard ownMaximumNumberOfLines >= maximumNumberOfLines else {
						return false
					}
				}
			}
			else {
				guard !isTruncated else {
					return false
				}
			}

			return true
		}


		@objc
 func layoutManager(_ layoutManager: NSLayoutManager, shouldSetLineFragmentRect lineFragmentRect: UnsafeMutablePointer<CGRect>, lineFragmentUsedRect: UnsafeMutablePointer<CGRect>, baselineOffset: UnsafeMutablePointer<CGFloat>, in textContainer: NSTextContainer, forGlyphRange glyphRange: NSRange) -> Bool {
			return true
		}


		func layoutManager(
			_ layoutManager: NSLayoutManager,
			shouldUseTemporaryAttributes attributes: [String : Any] = [:],
			forDrawingToScreen toScreen: Bool,
			atCharacterIndex charIndex: Int,
			effectiveRange effectiveCharRange: NSRangePointer?
		) -> [String : Any]? {
			guard toScreen else {
				return nil
			}

			var attributes = attributes

			if let textColor = attributes[NSForegroundColorAttributeName] as? UIColor {
				attributes[NSForegroundColorAttributeName] = textColor.tintedWithColor(drawingTintColor)
			}
			else {
				attributes[NSForegroundColorAttributeName] = drawingTextColor.tintedWithColor(drawingTintColor)
			}

			if let backgroundColor = attributes[NSBackgroundColorAttributeName] as? UIColor {
				attributes[NSBackgroundColorAttributeName] = backgroundColor.tintedWithColor(drawingTintColor)
			}

			return attributes
		}

/*

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

		*/



		struct Cache {

			private var layouts = [NSAttributedString : [TextLayout]]()


			mutating func add(layout: TextLayout) {
				if layouts[layout.text] != nil {
					layouts[layout.text]!.append(layout)
				}
				else {
					layouts[layout.text] = [layout]
				}
			}


			func get(forText text: NSAttributedString, maximumSize: CGSize, maximumNumberOfLines: Int?) -> TextLayout? {
				return layouts[text]?.first { $0.isValidFor(maximumSize: maximumSize, maximumNumberOfLines: maximumNumberOfLines) }
			}


			mutating func getOrCreate(forText text: NSAttributedString, maximumSize: CGSize, maximumNumberOfLines: Int?) -> TextLayout {
				if let layout = get(forText: text, maximumSize: maximumSize, maximumNumberOfLines: maximumNumberOfLines) {
					print("cache HIT")
					return layout
				}

				print("cache MISS")
				let layout = TextLayout(text: text, maximumSize: maximumSize, maximumNumberOfLines: maximumNumberOfLines)
				add(layout: layout)

				return layout
			}
		}



		private final class LayoutManager: NSLayoutManager {

			@objc(JetPack_linkAttributes)
			private dynamic class var linkAttributes: [AnyHashable: Any] {
				return [:]
			}


			override class func initialize() {
				guard self == LayoutManager.self else {
					return
				}

				let defaultLinkAttributesSelector = obfuscatedSelector("_", "default", "Link", "Attributes")
				copyMethod(selector: defaultLinkAttributesSelector, from: object_getClass(NSLayoutManager.self), to: object_getClass(self))
				swizzleMethod(in: object_getClass(self), from: #selector(getter: LayoutManager.linkAttributes), to: defaultLinkAttributesSelector)
			}
		}
	}


		/*
		@discardableResult
		func buildFinalText() -> FinalText {
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = horizontalAlignment
		paragraphStyle.lineBreakMode = .byWordWrapping // FIXME ??
		paragraphStyle.lineHeightMultiple = lineHeightMultiple

		var defaultAttributes: [String : Any] = [
		NSFontAttributeName:            font,
		NSForegroundColorAttributeName: color,
		NSParagraphStyleAttributeName:  paragraphStyle
		]

		if let kerning = kerning {
		let kerningValue: CGFloat
		switch kerning {
		case let .absolute(value):           kerningValue = value
		case let .relativeToFontSize(value): kerningValue = font.pointSize * value // TODO font may vary in attributed strings
		}

		defaultAttributes[NSKernAttributeName] = kerningValue as NSObject?
		}

		var textUsesTintColor = false

		let finalTextString = NSMutableAttributedString(string: text.string, attributes: defaultAttributes)
		finalTextString.edit {
		text.enumerateAttributes(in: NSRange(forString: text.string), options: [.longestEffectiveRangeNotRequired]) { attributes, range, _ in
		if let foregroundColor = attributes[NSForegroundColorAttributeName] as? UIColor, foregroundColor.tintAlpha != nil {
		textUsesTintColor = true
		}
		else if let backgroundColor = attributes[NSBackgroundColorAttributeName] as? UIColor, backgroundColor.tintAlpha != nil {
		textUsesTintColor = true
		}

		finalTextString.addAttributes(attributes, range: range)
		}

		if let transform = transform {
		let transformation: (String) -> String
		switch transform {
		case .capitalize: transformation = { $0.localizedCapitalized } // TODO this isn't 100% reliable when applying to segments instead of to the whole string
		case .lowercase:  transformation = { $0.localizedLowercase }
		case .uppercase:  transformation = { $0.localizedUppercase }
		}

		finalTextString.transformStringSegments(transformation)
		}
		}

		return FinalText(
		string:             finalTextString,
		dependsOnTintColor: textUsesTintColor
		)
		}
		*/
}

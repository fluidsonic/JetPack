import UIKit


internal class TextLayout {

	private let result: Result

	let configuration: Configuration


	private init(configuration: Configuration) {
		self.configuration = configuration
		self.result = Layouter.layout(configuration: configuration)
	}


	static func build(
		text: NSAttributedString,
		lineBreakMode: NSLineBreakMode,
		maximumNumberOfLines: Int?,
		maximumSize: CGSize,
		minimumScaleFactor: CGFloat,
		renderingScale: CGFloat,
		treatsLineFeedAsParagraphSeparator: Bool
	) -> TextLayout {
		precondition(maximumSize.isPositive, "maximumSize must be positive")
		precondition((0 ... 1).contains(minimumScaleFactor), "minimumScaleFactor must be in range 0 ... 1")
		precondition(renderingScale > 0, "renderingScale must be > 0")

		if let maximumNumberOfLines = maximumNumberOfLines {
			precondition(maximumNumberOfLines > 0, "maximumNumberOfLines must be > 0, or nil")
		}

		var treatsLineFeedAsParagraphSeparator = treatsLineFeedAsParagraphSeparator
		if treatsLineFeedAsParagraphSeparator && !text.string.contains("\n" as Character) {
			treatsLineFeedAsParagraphSeparator = false // improve cache hits
		}

		var minimumScaleFactor = minimumScaleFactor

		// Different callers may use different sizes to measure text without size constraints.
		// We unify to 100_000 so that caching works well for all the different cases between +100_000 and +infinity.
		var maximumSize = maximumSize
		if maximumSize.width > 100_000 {
			minimumScaleFactor = 1 // won't scale anyway if there is no constraint in width
			maximumSize.width = 100_000
		}
		if maximumSize.height > 100_000 {
			maximumSize.height = 100_000
		}

		let gridIncrement = 1 / renderingScale
		maximumSize.width = TextLayout.roundUpIgnoringErrors(maximumSize.width, increment: gridIncrement)
		maximumSize.height = TextLayout.roundUpIgnoringErrors(maximumSize.height, increment: gridIncrement)

		if maximumNumberOfLines != 1 {
			minimumScaleFactor = 1 // multi-line automatic font scaling is not yet supported
		}

		return reuseOrCreate(configuration: Configuration(
			lineBreakMode:                      lineBreakMode,
			maximumNumberOfLines:               maximumNumberOfLines,
			maximumSize:                        maximumSize,
			minimumScaleFactor:                 minimumScaleFactor,
			renderingScale:                     renderingScale,
			text:                               text,
			treatsLineFeedAsParagraphSeparator: treatsLineFeedAsParagraphSeparator
		))
	}


	var dependsOnTintColor: Bool {
		return result.dependsOnTintColor
	}


	func draw(in context: CGContext, defaultTextColor: UIColor, tintColor: UIColor) {
		Renderer.instance.draw(layout: self, in: context, defaultTextColor: defaultTextColor, tintColor: tintColor)
	}


	func enumerateEnclosingRects(forCharacterRange characterRange: NSRange, using block: ((_ enclosingRect: CGRect) -> Void)) {
		guard let layoutManager = result.layoutManager, let textContainer = result.textContainer else {
			return
		}

		let origin = result.frame.origin

		withoutActuallyEscaping(block) { block in
			let scaleFactor = result.scaleFactor

			let glyphRange = layoutManager.glyphRange(forCharacterRange: characterRange, actualCharacterRange: nil)
			layoutManager.enumerateEnclosingRects(forGlyphRange: glyphRange, withinSelectedGlyphRange: .notFound, in: textContainer) { enclosingRect, _ in
				var enclosingRect = enclosingRect.offsetBy(dx: -origin.x, dy: -origin.y)
				if scaleFactor < 1 {
					enclosingRect.left *= scaleFactor
					enclosingRect.top *= scaleFactor
					enclosingRect.widthFromLeft *= scaleFactor
					enclosingRect.heightFromTop *= scaleFactor
				}

				block(enclosingRect)
			}
		}
	}


	var isTruncated: Bool {
		return result.isTruncated
	}


	var numberOfLines: Int {
		return result.numberOfLines
	}


	func rect(forLine line: Int) -> CGRect {
		guard (0 ..< numberOfLines).contains(line), let layoutManager = result.layoutManager else {
			if line == 0 {
				return .zero
			}

			fatalError("Line index \(line) is out of range 0 ..< \(numberOfLines)")
		}

		let scaleFactor = result.scaleFactor
		var currentLine = 0
		var rect = CGRect.null

		let origin = result.frame.origin

		layoutManager.enumerateLineFragments(forGlyphRange: result.glyphRange) { _, usedRect, _, _, stop in
			if currentLine == line {
				rect = usedRect.offsetBy(dx: -origin.x, dy: -origin.y)

				if scaleFactor < 1 {
					rect.left *= scaleFactor
					rect.top *= scaleFactor
					rect.widthFromLeft *= scaleFactor
					rect.heightFromTop *= scaleFactor
				}

				stop.pointee = true
			}

			currentLine += 1
		}

		return rect
	}


	private static func reuseOrCreate(configuration: Configuration) -> TextLayout {
		if let layout = Cache.instance.get(for: configuration) {
			return layout
		}

		let layout = TextLayout(configuration: configuration)
		Cache.instance.add(layout)

		return layout
	}


	private static func roundDownIgnoringErrors(_ value: CGFloat, increment: CGFloat) -> CGFloat {
		var value = value
		value += (5 * value.ulp)

		return value.rounded(.down, increment: increment)
	}


	private static func roundUpIgnoringErrors(_ value: CGFloat, increment: CGFloat) -> CGFloat {
		var value = value
		value -= (5 * value.ulp)

		return value.rounded(.up, increment: increment)
	}


	var scaleFactor: CGFloat {
		return result.scaleFactor
	}


	var size: CGSize {
		return result.frame.size
	}



	// FIXME cache purging - we shouldn't grow the cache forever
	private struct Cache {

		static var instance = Cache()

		private var layouts = [TextLayout]()


		private init() {}


		mutating func add(_ layout: TextLayout) {
			// TODO possible optimization: drop other layouts which are also covered by this layout (happens when maxSize/NumberOfLines increases in subsequent layout generations)
			layouts.append(layout)
		}


		func get(for configuration: Configuration) -> TextLayout? {
			return layouts.first { layout($0, isAcceptableFor: configuration) }
		}


		private func layout(_ layout: TextLayout, isAcceptableFor configuration: Configuration) -> Bool {
			guard configuration.text == layout.configuration.text else {
				return false
			}

			guard configuration.lineBreakMode == layout.configuration.lineBreakMode else {
				// different line break mode will result in a different layout
				return false
			}
			guard configuration.renderingScale == layout.configuration.renderingScale else {
				// different rendering scale will result in a different layout
				return false
			}
			guard (configuration.maximumNumberOfLines ?? .max) >= layout.numberOfLines else {
				// allowing less lines than were already laid out will result in a different layout
				return false
			}
			guard !layout.result.isTruncated
				|| configuration.maximumNumberOfLines == layout.numberOfLines
				|| (layout.configuration.maximumNumberOfLines ?? .max) > layout.numberOfLines
			else {
				// allowing more lines could result in a different layout
				return false
			}
			guard (!layout.result.isTruncated && layout.result.scaleFactor >= 1) || configuration.minimumScaleFactor == layout.configuration.minimumScaleFactor else {
				// changing minimum scale factor if the text is truncated/scaled will result in a different layout
				return false
			}

			let layoutMaximumSize = layout.configuration.maximumSize
			let layoutSize = layout.result.frame.size

			let acceptableHeights = min(layoutSize.height, layoutMaximumSize.height) ... max(layoutSize.height, layoutMaximumSize.height)
			let acceptableWidths = min(layoutSize.width, layoutMaximumSize.width) ... max(layoutSize.width, layoutMaximumSize.width)
			guard acceptableHeights.contains(configuration.maximumSize.height) && acceptableWidths.contains(configuration.maximumSize.width) else {
				// maximum sizes lies outside of what we've laid out and may result in a different layout
				return false
			}

			return true
		}
	}



	struct Configuration: CustomDebugStringConvertible {

		var lineBreakMode: NSLineBreakMode
		var maximumNumberOfLines: Int?
		var maximumSize: CGSize
		var minimumScaleFactor: CGFloat
		var renderingScale: CGFloat
		var text: NSAttributedString
		var treatsLineFeedAsParagraphSeparator: Bool


		fileprivate init(
			lineBreakMode: NSLineBreakMode,
			maximumNumberOfLines: Int?,
			maximumSize: CGSize,
			minimumScaleFactor: CGFloat,
			renderingScale: CGFloat,
			text: NSAttributedString,
			treatsLineFeedAsParagraphSeparator: Bool
		) {
			self.lineBreakMode = lineBreakMode
			self.maximumNumberOfLines = maximumNumberOfLines
			self.maximumSize = maximumSize
			self.minimumScaleFactor = minimumScaleFactor
			self.renderingScale = renderingScale
			self.text = text
			self.treatsLineFeedAsParagraphSeparator = treatsLineFeedAsParagraphSeparator
		}


		var debugDescription: String {
			return "TextLayout.Configuration(lineBreakMode: \(lineBreakMode), maximumNumberOfLines: \(String(describing: maximumNumberOfLines)), maximumSize: \(maximumSize), minimumScaleFactor: \(minimumScaleFactor), renderingScale: \(renderingScale), text: '\(text.string)', treatsLineFeedAsParagraphSeparator: \(treatsLineFeedAsParagraphSeparator))"
		}
	}



	private class Layouter: NSObject, NSLayoutManagerDelegate {

		private let configuration: Configuration
		private var firstLineBaselineOffsetFromBottom = CGFloat.zero
		private var truncationLocation: Int?


		private init(configuration: Configuration) {
			self.configuration = configuration
		}


		static func layout(configuration: Configuration) -> Result {
			return Layouter(configuration: configuration).layout()
		}


		private func layout() -> Result {
			guard let text = configuration.text.nonEmpty else {
				return .empty(isTruncated: false)
			}

			let textContainerSize = CGSize(width: configuration.maximumSize.width / configuration.minimumScaleFactor, height: configuration.maximumSize.height)

			let textContainer = NSTextContainer(size: textContainerSize)
			textContainer.lineBreakMode = configuration.lineBreakMode
			textContainer.lineFragmentPadding = 0
			textContainer.maximumNumberOfLines = configuration.maximumNumberOfLines ?? 0

			let layoutManager = LayoutManager()
			layoutManager.delegate = self
			defer { layoutManager.delegate = nil }
			layoutManager.usesFontLeading = false
			layoutManager.addTextContainer(textContainer)

			let textStorage = NSTextStorage(attributedString: configuration.text)
			textStorage.addLayoutManager(layoutManager)

			layoutManager.ensureLayout(forBoundingRect: CGRect(size: textContainerSize), in: textContainer)

			var visibleGlyphRange = layoutManager.glyphRange(for: textContainer)
			guard visibleGlyphRange.length > 0 else {
				return .empty(isTruncated: true)
			}

			let visibleCharacterRange = layoutManager.characterRange(forGlyphRange: visibleGlyphRange, actualGlyphRange: nil)

			var isTruncated = visibleGlyphRange.endLocation < layoutManager.numberOfGlyphs
			var hasAutomaticTruncationIndication = false
			var lastLineCharacterRange = NSRange(location: 0, length: 0)

			var lineIndex = 0
			layoutManager.enumerateLineFragments(forGlyphRange: visibleGlyphRange) { rectForLine, usedRectForLine, _, glyphRangeForLine, _ in
				lastLineCharacterRange = layoutManager.characterRange(forGlyphRange: glyphRangeForLine, actualGlyphRange: nil)

				if !hasAutomaticTruncationIndication {
					let truncatedGlyphRange = layoutManager.truncatedGlyphRange(inLineFragmentForGlyphAt: glyphRangeForLine.location)
					if truncatedGlyphRange.length > 0 {
						hasAutomaticTruncationIndication = true
						isTruncated = true
					}
				}

				lineIndex += 1
			}

			// Text was trucated and the line break mode demands an ellipsis but NSLayoutManager was too lazy to add one, so we do it instead.
			if isTruncated && !hasAutomaticTruncationIndication {
				switch configuration.lineBreakMode {
				case .byTruncatingHead, .byTruncatingMiddle, .byTruncatingTail:
					let string = text.string as NSString

					var truncationLocation = lastLineCharacterRange.endLocation - 1
					while let character = UnicodeScalar(string.character(at: truncationLocation)), CharacterSet.whitespacesAndNewlines.contains(character) {
						truncationLocation -= 1

						if truncationLocation < lastLineCharacterRange.location {
							break
						}
					}

					truncationLocation += 1
					self.truncationLocation = truncationLocation

					let truncatedRange = NSRange(location: truncationLocation, length: text.length - truncationLocation)
					layoutManager.invalidateGlyphs(forCharacterRange: truncatedRange, changeInLength: 0, actualCharacterRange: nil)
					layoutManager.invalidateLayout(forCharacterRange: truncatedRange, actualCharacterRange: nil)
					layoutManager.ensureLayout(forBoundingRect: CGRect(size: textContainerSize), in: textContainer)

					visibleGlyphRange = layoutManager.glyphRange(for: textContainer)

				default:
					break
				}
			}

			// Check whether the visible text depends on the tint color.
			// Enables optimizations where users of the TextLayout can prevent unecessary redraws when the tint color changes.
			var dependsOnTintColor = false
			textStorage.enumerateAttributes(in: visibleCharacterRange, options: .longestEffectiveRangeNotRequired) { attributes, _, stop in
				if let textColor = attributes[.foregroundColor] as? UIColor, textColor.tintAlpha != nil {
					dependsOnTintColor = true
					stop.pointee = true
				}
				else if let backgroundColor = attributes[.foregroundColor] as? UIColor, backgroundColor.tintAlpha != nil {
					dependsOnTintColor = true
					stop.pointee = true
				}
			}

			var numberOfLines = 0
			layoutManager.enumerateLineFragments(forGlyphRange: visibleGlyphRange) { _, _, _, _, _ in numberOfLines += 1 }

			var frame = layoutManager.usedRect(for: textContainer)

			// If scaling is allowed, figure out how much we had to scale in order to make the text fit.
			let scaleFactor: CGFloat
			if configuration.minimumScaleFactor < 1 {
				scaleFactor = (configuration.maximumSize.width / frame.width).coerced(atMost: 1)

				frame.origin.left *= scaleFactor
				frame.origin.top *= scaleFactor
				frame.size = frame.size.scale(by: scaleFactor)
			}
			else {
				scaleFactor = 1
			}

			return Result(
				dependsOnTintColor: dependsOnTintColor,
				frame:              frame,
				glyphRange:         visibleGlyphRange,
				isTruncated:        isTruncated,
				layoutManager:      layoutManager,
				numberOfLines:      numberOfLines,
				scaleFactor:        scaleFactor,
				textContainer:      textContainer,
				textStorage:        textStorage
			)
		}


		func layoutManager(
			_ layoutManager: NSLayoutManager,
			paragraphSpacingAfterGlyphAt glyphIndex: Int,
			withProposedLineFragmentRect rect: CGRect
		) -> CGFloat {
			// paragraph spacing is handled in shouldSetLineFragmentRect delegte method
			return 0
		}


		func layoutManager(
			_ layoutManager: NSLayoutManager,
			shouldSetLineFragmentRect lineFragmentRect: UnsafeMutablePointer<CGRect>,
			lineFragmentUsedRect: UnsafeMutablePointer<CGRect>,
			baselineOffset: UnsafeMutablePointer<CGFloat>,
			in textContainer: NSTextContainer,
			forGlyphRange glyphRange: NSRange
		) -> Bool {
			let characterRange = layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
			let lineStyle = configuration.text.lineStyle(for: characterRange)

			if let paragraphSpacing = lineStyle.maximumParagraphSpacing, paragraphSpacing != 0 {
				let lastCharacter = (configuration.text.string as NSString).character(at: characterRange.endLocation - 1)
				if
					lastCharacter == 0x2029 || // <paragraph separator>
					(configuration.treatsLineFeedAsParagraphSeparator && lastCharacter == 0x000A) // <line feed>
				{
					lineFragmentRect.pointee.heightFromTop += paragraphSpacing
				}
			}

			let isFirstLine = glyphRange.location == 0
			if isFirstLine {
				if let maximumFontLineHeight = lineStyle.maximumFontLineHeight, let offsetForVerticalCentering = lineStyle.offsetForVerticalCentering {
					baselineOffset.pointee += offsetForVerticalCentering + ((maximumFontLineHeight - lineFragmentUsedRect.pointee.height) / 2)
				}

				// TODO This depends on this delegate method getting called exactly once at the beginning for the first line. Is there a better way?
				firstLineBaselineOffsetFromBottom = lineFragmentUsedRect.pointee.height - baselineOffset.pointee
			}
			else {
				baselineOffset.pointee = lineFragmentUsedRect.pointee.height - firstLineBaselineOffsetFromBottom
			}

			return true
		}


		func layoutManager(
			_ layoutManager: NSLayoutManager,
			shouldGenerateGlyphs glyphs: UnsafePointer<CGGlyph>,
			properties: UnsafePointer<NSLayoutManager.GlyphProperty>,
			characterIndexes: UnsafePointer<Int>,
			font: UIFont,
			forGlyphRange glyphRange: NSRange
		) -> Int {
			guard let truncationLocation = truncationLocation else {
				return 0
			}

			let characterRange = NSRange(location: characterIndexes.pointee, length: characterIndexes[glyphRange.length - 1] + 1)
			guard characterRange.endLocation > truncationLocation else {
				return 0
			}

			var newGlyphs = Array(UnsafeBufferPointer(start: glyphs, count: glyphRange.length))
			var newProperties = Array(UnsafeBufferPointer(start: properties, count: glyphRange.length))

			if characterRange.contains(truncationLocation) {
				var ellipsis: UniChar = 0x2026 // <ellipsis>
				var ellipsisGlyph: CGGlyph = 0
				if CTFontGetGlyphsForCharacters(font as CTFont, &ellipsis, &ellipsisGlyph, 1) {
					for index in 0 ..< glyphRange.length {
						let characterIndex = characterIndexes[index]
						if characterIndex == truncationLocation {
							newGlyphs[index] = ellipsisGlyph
							newProperties[index] = []

							break
						}
					}
				}
			}

			for index in 0 ..< glyphRange.length {
				let characterIndex = characterIndexes[index]
				if characterIndex > truncationLocation {
					newGlyphs[index] = kCGFontIndexInvalid
					newProperties[index] = [] // .null sometimes causes blank space at the end of the text
				}
			}

			layoutManager.setGlyphs(
				newGlyphs,
				properties:       newProperties,
				characterIndexes: characterIndexes,
				font:             font,
				forGlyphRange:    glyphRange
			)

			return glyphRange.length
		}
	}



	fileprivate class LayoutManager: NSLayoutManager {

		@objc(JetPack_linkAttributes)
		fileprivate dynamic class var linkAttributes: [AnyHashable: Any] {
			return [:]
		}
	}



	private class Renderer: NSObject, NSLayoutManagerDelegate {

		static let instance = Renderer()

		private var defaultTextColor = UIColor.red
		private var tintColor = UIColor.red


		private override init() {
			super.init()
		}


		func draw(layout: TextLayout, in context: CGContext, defaultTextColor: UIColor, tintColor: UIColor) {
			let glyphRange = layout.result.glyphRange
			guard glyphRange.length > 0, let layoutManager = layout.result.layoutManager else {
				return
			}

			UIGraphicsPushContext(context)
			defer { UIGraphicsPopContext() }

			let scaleFactor = layout.result.scaleFactor
			if scaleFactor < 1 {
				context.saveGState()
				context.scaleBy(x: scaleFactor, y: scaleFactor)
			}

			self.defaultTextColor = defaultTextColor.tinted(with: tintColor)
			self.tintColor = tintColor

			layoutManager.delegate = self
			layoutManager.drawBackground(forGlyphRange: glyphRange, at: -layout.result.frame.origin)
			layoutManager.drawGlyphs(forGlyphRange: glyphRange, at: -layout.result.frame.origin)
			layoutManager.delegate = nil

			if scaleFactor < 1 {
				context.restoreGState()
			}
		}


		@objc
		func layoutManager(
			_ layoutManager: NSLayoutManager,
			shouldUseTemporaryAttributes attributes: [String : Any] = [:],
			forDrawingToScreen toScreen: Bool,
			atCharacterIndex charIndex: Int,
			effectiveRange effectiveCharRange: NSRangePointer?
		) -> [NSAttributedString.Key : Any]? {
			guard toScreen, let textStorage = layoutManager.textStorage else {
				return nil
			}

			var attributes = textStorage.attributes(at: charIndex, effectiveRange: nil)

			if let textColor = attributes[.foregroundColor] as? UIColor {
				attributes[.foregroundColor] = textColor.tinted(with: tintColor)
			}
			else {
				attributes[.foregroundColor] = defaultTextColor
			}

			if let backgroundColor = attributes[.backgroundColor] as? UIColor {
				attributes[.backgroundColor] = backgroundColor.tinted(with: tintColor)
			}

			return attributes
		}
	}


	private struct Result {

		let dependsOnTintColor: Bool
		let frame: CGRect
		let glyphRange: NSRange
		let isTruncated: Bool
		let layoutManager: NSLayoutManager?
		let numberOfLines: Int
		let scaleFactor: CGFloat
		let textContainer: NSTextContainer?
		let textStorage: NSTextStorage? // NSLayoutManager only maintains a weak reference


		static func empty(isTruncated: Bool) -> Result {
			return Result(
				dependsOnTintColor: false,
				frame:              .zero,
				glyphRange:         .notFound,
				isTruncated:        isTruncated,
				layoutManager:      nil,
				numberOfLines:      0,
				scaleFactor:        1,
				textContainer:      nil,
				textStorage:        nil
			)
		}
	}
}


@objc(_JetPack_UI_TextLayout_Initialization)
private class StaticInitialization: NSObject, StaticInitializable {

	static func staticInitialize() {
		let defaultLinkAttributesSelector = obfuscatedSelector("_", "default", "Link", "Attributes")
		copyMethod(selector: defaultLinkAttributesSelector, from: object_getClass(NSLayoutManager.self)!, to: object_getClass(TextLayout.LayoutManager.self)!)
		swizzleMethod(in: object_getClass(TextLayout.LayoutManager.self)!, from: #selector(getter: TextLayout.LayoutManager.linkAttributes), to: defaultLinkAttributesSelector)
	}
}


private extension NSAttributedString {

	@nonobjc
	func lineStyle(for range: NSRange) -> LineStyle {
		var maximumFontLineHeight: CGFloat?
		var maximumParagraphSpacing: CGFloat?
		var offsetForVerticalCentering: CGFloat?

		enumerateAttributes(in: range, options: .longestEffectiveRangeNotRequired) { attributes, _, _ in
			if let paragraphStyle = attributes[.paragraphStyle] as? NSParagraphStyle {
				maximumParagraphSpacing = optionalMax(maximumParagraphSpacing, paragraphStyle.paragraphSpacing)
			}
			if let font = attributes[.font] as? UIFont {
				let topSpace = font.ascender - font.capHeight
				let bottomSpace = -font.descender
				offsetForVerticalCentering = optionalMin(offsetForVerticalCentering, (bottomSpace - topSpace) / 2)

				maximumFontLineHeight = optionalMax(maximumFontLineHeight, font.lineHeight)
			}
		}

		return LineStyle(
			maximumFontLineHeight:      maximumFontLineHeight,
			maximumParagraphSpacing:    maximumParagraphSpacing,
			offsetForVerticalCentering: offsetForVerticalCentering
		)
	}



	struct LineStyle {

		var maximumFontLineHeight: CGFloat?
		var maximumParagraphSpacing: CGFloat?
		var offsetForVerticalCentering: CGFloat?
	}
}

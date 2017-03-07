import UIKit


internal class TextLayout {

	private let result: Result

	internal let configuration: Configuration


	private init(configuration: Configuration) {
		self.configuration = configuration
		self.result = TextLayout.resolve(configuration: configuration)
	}


	internal static func build(
		text: NSAttributedString,
		lineBreakMode: NSLineBreakMode,
		maximumNumberOfLines: Int?,
		maximumSize: CGSize,
		minimumScaleFactor: CGFloat,
		renderingScale: CGFloat,
		usesExactMeasuring: Bool
	) -> TextLayout {
		precondition(maximumSize.isPositive, "maximumSize must be positive")
		precondition((0 ... 1).contains(minimumScaleFactor), "minimumScaleFactor must be in range 0...1")
		precondition(renderingScale > 0, "renderingScale must be > 0")

		if let maximumNumberOfLines = maximumNumberOfLines {
			precondition(maximumNumberOfLines > 0, "maximumNumberOfLines must be > 0, or nil")
		}

		// Different callers may use different sizes to measure text without size constraints.
		// We unify to +infinity so that caching works well for all the different cases between +100_000 and +infinity.
		var maximumSize = maximumSize
		if maximumSize.width > 100_000 {
			maximumSize.width = .infinity
		}
		if maximumSize.height > 100_000 {
			maximumSize.height = .infinity
		}

		var minimumScaleFactor = minimumScaleFactor
		if maximumNumberOfLines != 1 {
			// multi-line automatic font scaling is not yet supported
			minimumScaleFactor = 1
		}

		return forConfiguration(Configuration(
			lineBreakMode:        lineBreakMode,
			maximumNumberOfLines: maximumNumberOfLines ?? Int.max,
			maximumSize:          maximumSize,
			minimumScaleFactor:   minimumScaleFactor,
			renderingScale:       renderingScale,
			text:                 text,
			usesExactMeasuring:   usesExactMeasuring
		))
	}


	internal var contentInsets: UIEdgeInsets {
		return result.contentInsets
	}


	internal var dependsOnTintColor: Bool {
		return result.dependsOnTintColor
	}


	internal func draw(in context: CGContext, defaultTextColor: UIColor, tintColor: UIColor) {
		Renderer.instance.draw(layout: self, in: context, defaultTextColor: defaultTextColor, tintColor: tintColor)
	}


	internal func enumerateEnclosingRects(forCharacterRange characterRange: NSRange, using block: ((CGRect) -> Void)) {
		let block = makeEscapable(block)
		let contentInsets = result.contentInsets
		let origin = result.origin
		let scaleFactor = result.scaleFactor

		let glyphRange = result.layoutManager.glyphRange(forCharacterRange: characterRange, actualCharacterRange: nil)
		result.layoutManager.enumerateEnclosingRects(forGlyphRange: glyphRange, withinSelectedGlyphRange: .notFound, in: result.textContainer) { enclosingRect, _ in
			var enclosingRect = enclosingRect
			if scaleFactor < 1 {
				enclosingRect.left *= scaleFactor
				enclosingRect.top *= scaleFactor
				enclosingRect.width *= scaleFactor
				enclosingRect.height *= scaleFactor
			}

			enclosingRect.left += origin.left + contentInsets.left
			enclosingRect.top += origin.top + contentInsets.top

			block(enclosingRect)
		}
	}


	private static func forConfiguration(_ configuration: Configuration) -> TextLayout {
		if let layout = Cache.instance.get(for: configuration) {
			print("Cache HIT:  \(configuration)")
			return layout
		}

		print("Cache MISS: \(configuration)")

		let layout = TextLayout(configuration: configuration)
		Cache.instance.add(layout)

		return layout
	}


	internal var numberOfLines: Int {
		return result.numberOfLines
	}


	private static func resolve(configuration: Configuration) -> Result {
		let textContainer = NSTextContainer(size: configuration.maximumSize.scaleBy(1 / configuration.minimumScaleFactor))
		textContainer.lineBreakMode = configuration.lineBreakMode
		textContainer.lineFragmentPadding = 0
		textContainer.maximumNumberOfLines = configuration.maximumNumberOfLines == Int.max ? 0 : configuration.maximumNumberOfLines

		let layoutManager = LayoutManager()
		layoutManager.usesFontLeading = true
		layoutManager.addTextContainer(textContainer)

		let textStorage = NSTextStorage(attributedString: configuration.text)
		textStorage.addLayoutManager(layoutManager)

		let string = textStorage.string

		// TODO this is unreliable to determine the visibleGlyphRange
		var visibleGlyphRange = layoutManager.glyphRange(forBoundingRect: layoutManager.usedRect(for: textContainer), in: textContainer)
		var isTruncated = visibleGlyphRange.endLocation < layoutManager.numberOfGlyphs
		var dependsOnTintColor = false

		if visibleGlyphRange.length > 0 {
			let lastGlyphIndex = visibleGlyphRange.endLocation - 1
			let truncationGlyphRange = layoutManager.truncatedGlyphRange(inLineFragmentForGlyphAt: lastGlyphIndex)
			if truncationGlyphRange.length > 0 {
				isTruncated = true
			}

			// Remove trailing whitespace from last line to reflect UILabel's default behavior.
			// Not necessary if truncation happend since in that case NSLayoutManager will do that on its own…
			if truncationGlyphRange.location == NSNotFound {
				var glyphRangeForLine = NSRange()
				let usedRectForLine = layoutManager.lineFragmentUsedRect(forGlyphAt: lastGlyphIndex, effectiveRange: &glyphRangeForLine)

				// only if it's not also the first line
				if glyphRangeForLine.location != visibleGlyphRange.location {
					let rectForLine = layoutManager.lineFragmentRect(forGlyphAt: lastGlyphIndex, effectiveRange: nil)
					let characterRangeForLine = layoutManager.characterRange(forGlyphRange: glyphRangeForLine, actualGlyphRange: nil)
					let stringForLine = string[characterRangeForLine.rangeInString(string)!]

					var truncatedCharacterRangeForLine = characterRangeForLine
					let charactersToRemoveFromEndOfLine = CharacterSet.whitespacesAndNewlines
					for character in stringForLine.unicodeScalars.reversed() {
						guard charactersToRemoveFromEndOfLine.contains(character) else {
							break
						}

						truncatedCharacterRangeForLine.length -= 1
					}

					if truncatedCharacterRangeForLine.length < characterRangeForLine.length {
						let truncatedGlyphRangeForLine = layoutManager.glyphRange(forCharacterRange: truncatedCharacterRangeForLine, actualCharacterRange: nil).clamped(to: glyphRangeForLine)
						if truncatedGlyphRangeForLine != glyphRangeForLine {
							var truncatedUsedRectForLine = CGRect.null
							layoutManager.enumerateEnclosingRects(forGlyphRange: truncatedGlyphRangeForLine, withinSelectedGlyphRange: .notFound, in: textContainer) { glyphRect, _ in
								truncatedUsedRectForLine = truncatedUsedRectForLine.union(glyphRect)
							}
							if truncatedUsedRectForLine.isNull {
								truncatedUsedRectForLine = usedRectForLine
								truncatedUsedRectForLine.width = 0
							}

							layoutManager.setLineFragmentRect(rectForLine, forGlyphRange: glyphRangeForLine, usedRect: truncatedUsedRectForLine)

							visibleGlyphRange = NSRange(location: visibleGlyphRange.location, length: truncatedGlyphRangeForLine.endLocation - visibleGlyphRange.location)
						}
					}
				}
			}

			let visibleCharacterRange = layoutManager.characterRange(forGlyphRange: visibleGlyphRange, actualGlyphRange: nil)
			textStorage.enumerateAttributes(in: visibleCharacterRange, options: .longestEffectiveRangeNotRequired) { attributes, _, stop in
				if let textColor = attributes[NSForegroundColorAttributeName] as? UIColor, textColor.tintAlpha != nil {
					dependsOnTintColor = true
					stop.pointee = true
					return
				}

				if let backgroundColor = attributes[NSForegroundColorAttributeName] as? UIColor, backgroundColor.tintAlpha != nil {
					dependsOnTintColor = true
					stop.pointee = true
					return
				}
			}

			// layoutManager's bounding rectangle won't be calculated correctly unless we tell it to do so…
			for glyphIndex in visibleGlyphRange {
				layoutManager.setDrawsOutsideLineFragment(true, forGlyphAt: glyphIndex)
			}
		}

		var boundingRect = CGRect.null
		var numberOfLines = 0
		var usedRect = CGRect.null
		let grid = 1 / configuration.renderingScale

		layoutManager.enumerateLineFragments(forGlyphRange: visibleGlyphRange) { _, usedRectForLine, _, glyphRangeForLine, stop in
			guard numberOfLines < configuration.maximumNumberOfLines else {
				stop.pointee = true
				return
			}

			var usedRectForLine = usedRectForLine
			var glyphRangeForLine = glyphRangeForLine
			let characterRangeForLine = layoutManager.characterRange(forGlyphRange: glyphRangeForLine, actualGlyphRange: nil)

			// boundingRect is unreliable when the range ends with a newline character, so we'll exclude it
			if glyphRangeForLine.length > 0,
				let characterRangeForLine = characterRangeForLine.rangeInString(string),
				let lastCharacter = string[characterRangeForLine].unicodeScalars.last,
				CharacterSet.newlines.contains(lastCharacter)
			{
				glyphRangeForLine.length -= 1
			}

			var boundingRectForLine = layoutManager.boundingRect(forGlyphRange: glyphRangeForLine, in: textContainer)

			// remove spacing above capital letters of first line and below baseline of last line
			if configuration.usesExactMeasuring {
				let isFirstLine = (glyphRangeForLine.location == visibleGlyphRange.location)
				let isLastLine = (glyphRangeForLine.endLocation >= visibleGlyphRange.endLocation)
				if isFirstLine || isLastLine {
					// FIXME we also have to remove spacing *during* layout in order fully use maximumSize (using layoutManager delegate) - but may work for now due to the layout cache -> disable it for proper testing
					if let capitalLetterSpacingForLine = textStorage.capitalLetterSpacing(in: characterRangeForLine, forLineHeight: usedRectForLine.height, usingFontLeading: layoutManager.usesFontLeading) {
						if isFirstLine {
							let spacing = capitalLetterSpacingForLine.above.rounded(increment: grid)
							// FIXME don't modify usedRect as it's needed for stuff like firstLineHeadIndent
							usedRectForLine.top += spacing
							usedRectForLine.height -= spacing
							boundingRectForLine.top -= spacing
							boundingRectForLine.height += spacing
						}
						if isLastLine {
							let spacing = capitalLetterSpacingForLine.below.rounded(increment: grid)
							usedRectForLine.height -= spacing
							boundingRectForLine.height += spacing
						}
					}
				}
			}

			boundingRect = boundingRect.union(boundingRectForLine)
			numberOfLines += 1
			usedRect = usedRect.union(usedRectForLine)
		}

		let scaleFactor: CGFloat

		if boundingRect.isNull {
			boundingRect = .zero
			usedRect = .zero

			scaleFactor = 1
		}
		else {
			if configuration.minimumScaleFactor < 1 {
				scaleFactor = min(configuration.maximumSize.width / usedRect.width, configuration.maximumSize.height / usedRect.height).coerced(atMost: 1)
				if scaleFactor < 1 {
					boundingRect.left *= scaleFactor
					boundingRect.top *= scaleFactor
					boundingRect.size.scaleInPlace(scaleFactor)

					usedRect.left *= scaleFactor
					usedRect.top *= scaleFactor
					usedRect.size.scaleInPlace(scaleFactor)
				}
			}
			else {
				scaleFactor = 1
			}

			boundingRect.left = boundingRect.left.rounded(.down, increment: grid)
			boundingRect.top = boundingRect.top.rounded(.down, increment: grid)
			boundingRect.width = boundingRect.width.rounded(.up, increment: grid)
			boundingRect.height = boundingRect.height.rounded(.up, increment: grid)

			usedRect.height = usedRect.height.rounded(.up, increment: grid)
			usedRect.width = usedRect.width.rounded(.up, increment: grid)
		}

		let contentInsets = UIEdgeInsets(fromRect: usedRect, toRect: boundingRect)
		let origin = CGPoint(left: -boundingRect.left, top: -boundingRect.top)

		return Result(
			contentInsets:      contentInsets,
			dependsOnTintColor: dependsOnTintColor,
			glyphRange:         visibleGlyphRange,
			isTruncated:        isTruncated,
			layoutManager:      layoutManager,
			numberOfLines:      numberOfLines,
			origin:             origin,
			scaleFactor:       scaleFactor,
			size:               usedRect.size,
			textContainer:      textContainer,
			textStorage:        textStorage
		)
	}


	internal var size: CGSize {
		return result.size
	}



	// FIXME cache purging - we shouldn't grow the cache forever
	private struct Cache {

		static var instance = Cache()

		private var layouts = [TextLayout]()


		private init() {}


		mutating func add(_ layout: TextLayout) {
			// TODO possible optimization: drop other layouts which are also covered by this layout (happens when maxSize/NumberOfLines increases in subsequent layout geenrations)
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
			guard configuration.usesExactMeasuring == layout.configuration.usesExactMeasuring else {
				// different measuring will result in a different layout
				return false
			}

			guard configuration.maximumNumberOfLines >= layout.result.numberOfLines else {
				// allowing less lines than were already laid out will result in a different layout
				return false
			}
			guard !layout.result.isTruncated || configuration.maximumNumberOfLines == layout.result.numberOfLines || layout.configuration.maximumNumberOfLines > layout.result.numberOfLines else {
				// allowing more lines could result in a different layout
				return false
			}

			guard (!layout.result.isTruncated && layout.result.scaleFactor >= 1) || configuration.minimumScaleFactor == layout.configuration.minimumScaleFactor else {
				// changing minimum scale factor if the text is truncated/scaled will result in a different layout
				return false
			}

			let layoutMaximumSize = layout.configuration.maximumSize
			let layoutSize = layout.result.size

			let acceptableHeights = min(layoutSize.height, layoutMaximumSize.height) ... max(layoutSize.height, layoutMaximumSize.height)
			let acceptableWidths = min(layoutSize.width, layoutMaximumSize.width) ... max(layoutSize.width, layoutMaximumSize.width)
			guard acceptableHeights.contains(configuration.maximumSize.height) && acceptableWidths.contains(configuration.maximumSize.width) else {
				// maximum sizes lies outside of what we've laid out and may result in a different layout
				return false
			}

			return true
		}
	}



	internal struct Configuration: CustomDebugStringConvertible {

		var lineBreakMode: NSLineBreakMode
		var maximumNumberOfLines: Int
		var maximumSize: CGSize
		var minimumScaleFactor: CGFloat
		var renderingScale: CGFloat
		var text: NSAttributedString
		var usesExactMeasuring: Bool


		fileprivate init(
			lineBreakMode: NSLineBreakMode,
			maximumNumberOfLines: Int,
			maximumSize: CGSize,
			minimumScaleFactor: CGFloat,
			renderingScale: CGFloat,
			text: NSAttributedString,
			usesExactMeasuring: Bool
		) {
			self.lineBreakMode = lineBreakMode
			self.maximumNumberOfLines = maximumNumberOfLines
			self.maximumSize = maximumSize
			self.minimumScaleFactor = minimumScaleFactor
			self.renderingScale = renderingScale
			self.text = text
			self.usesExactMeasuring = usesExactMeasuring
		}


		var debugDescription: String {
			return "TextLayout.Configuration(lineBreakMode: \(lineBreakMode), maximumNumberOfLines: \(maximumNumberOfLines == Int.max ? "-" : String(maximumNumberOfLines)), maximumSize: \(maximumSize), minimumScaleFactor: \(minimumScaleFactor), renderingScale: \(renderingScale), text: '\(text.string)', usesExactMeasuring: \(usesExactMeasuring))"
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



	private class Renderer: NSObject, NSLayoutManagerDelegate {

		static let instance = Renderer()

		private var defaultTextColor = UIColor.red
		private var tintColor = UIColor.red


		private override init() {
			super.init()
		}


		func draw(layout: TextLayout, in context: CGContext, defaultTextColor: UIColor, tintColor: UIColor) {
			let glyphRange = layout.result.glyphRange
			guard glyphRange.length > 0 else {
				return
			}

			UIGraphicsPushContext(context)
			defer { UIGraphicsPopContext() }

			let scaleFactor = layout.result.scaleFactor
			if scaleFactor < 1 {
				context.saveGState()
				context.scaleBy(x: scaleFactor, y: scaleFactor)
			}

			self.defaultTextColor = defaultTextColor.tintedWithColor(tintColor)
			self.tintColor = tintColor

			let layoutManager = layout.result.layoutManager

			var origin = layout.result.origin
			origin.left /= scaleFactor
			origin.top /= scaleFactor

			layoutManager.delegate = self
			layoutManager.drawBackground(forGlyphRange: glyphRange, at: origin)
			layoutManager.drawGlyphs(forGlyphRange: glyphRange, at: origin)

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
		) -> [String : Any]? {
			guard toScreen, let textStorage = layoutManager.textStorage else {
				return nil
			}

			var attributes = textStorage.attributes(at: charIndex, effectiveRange: nil)

			if let textColor = attributes[NSForegroundColorAttributeName] as? UIColor {
				attributes[NSForegroundColorAttributeName] = textColor.tintedWithColor(tintColor)
			}
			else {
				attributes[NSForegroundColorAttributeName] = defaultTextColor
			}

			if let backgroundColor = attributes[NSBackgroundColorAttributeName] as? UIColor {
				attributes[NSBackgroundColorAttributeName] = backgroundColor.tintedWithColor(tintColor)
			}

			return attributes
		}
	}


	private struct Result {

		var contentInsets: UIEdgeInsets
		var dependsOnTintColor: Bool
		var glyphRange: NSRange
		var isTruncated: Bool
		var layoutManager: LayoutManager
		var numberOfLines: Int
		var origin: CGPoint
		var scaleFactor: CGFloat
		var size: CGSize
		var textContainer: NSTextContainer
		var textStorage: NSTextStorage // NSLayoutManager only maintains a weak reference
	}
}

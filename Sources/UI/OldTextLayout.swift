import UIKit

/*
  TODO

  - Truncating (using …) is unreliable. NSLayoutManager doesn't return a consistent layout here.
    Detecting whether truncation actually happened is also unreliable. We should do truncation on our own.
    For now we rely on the caching to mitigate most instances of this issue.

  - Various features of NSParagraphStyle are not supported yet, including justified text and tab stops.
    In general it's not possible to have a single layout pass for both, measuring and laying out text.
*/


internal class OldTextLayout {

	private static let maximumLayoutIterationCount = 3

	private let result: Result

	internal let configuration: Configuration


	private init(configuration: Configuration) {
		self.configuration = configuration
		self.result = Layouter.layout(configuration: configuration)
	}


	internal static func build(
		text: NSAttributedString,
		highPrecision: Bool,
		lineBreakMode: NSLineBreakMode,
		maximumNumberOfLines: Int?,
		maximumSize: CGSize,
		minimumScaleFactor: CGFloat,
		renderingScale: CGFloat
	) -> OldTextLayout {
		precondition(maximumSize.isPositive, "maximumSize must be positive")
		precondition((0 ... 1).contains(minimumScaleFactor), "minimumScaleFactor must be in range 0...1")
		precondition(renderingScale > 0, "renderingScale must be > 0")

		if let maximumNumberOfLines = maximumNumberOfLines {
			precondition(maximumNumberOfLines > 0, "maximumNumberOfLines must be > 0, or nil")
		}

		// Different callers may use different sizes to measure text without size constraints.
		// We unify to 1_000_000 so that caching works well for all the different cases between +100_000 and +infinity.
		var maximumSize = maximumSize
		if maximumSize.width > 100_000 {
			maximumSize.width = 1_000_000
		}
		if maximumSize.height > 100_000 {
			maximumSize.height = 1_000_000
		}

		let gridIncrement = 1 / renderingScale
		maximumSize.width = OldTextLayout.roundUpIgnoringErrors(maximumSize.width, increment: gridIncrement)
		maximumSize.height = OldTextLayout.roundUpIgnoringErrors(maximumSize.height, increment: gridIncrement)

		var minimumScaleFactor = minimumScaleFactor
		if maximumNumberOfLines != 1 {
			// multi-line automatic font scaling is not yet supported
			minimumScaleFactor = 1
		}

		return forConfiguration(Configuration(
			highPrecision:        highPrecision,
			lineBreakMode:        lineBreakMode,
			maximumNumberOfLines: maximumNumberOfLines ?? Int.max,
			maximumSize:          maximumSize,
			minimumScaleFactor:   minimumScaleFactor,
			renderingScale:       renderingScale,
			text:                 text
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
		withoutActuallyEscaping(block) { block in
			let contentInsets = result.contentInsets
			let origin = result.origin
			let scaleFactor = result.scaleFactor

			let glyphRange = result.layoutManager.glyphRange(forCharacterRange: characterRange, actualCharacterRange: nil)
			result.layoutManager.enumerateEnclosingRects(forGlyphRange: glyphRange, withinSelectedGlyphRange: .notFound, in: result.textContainer) { enclosingRect, _ in
				var enclosingRect = enclosingRect
				if scaleFactor < 1 {
					enclosingRect.left *= scaleFactor
					enclosingRect.top *= scaleFactor
					enclosingRect.widthFromLeft *= scaleFactor
					enclosingRect.heightFromTop *= scaleFactor
				}

				enclosingRect.left += origin.left + contentInsets.left
				enclosingRect.top += origin.top + contentInsets.top

				block(enclosingRect)
			}
		}
	}


	private static func forConfiguration(_ configuration: Configuration) -> OldTextLayout {
		if let layout = Cache.instance.get(for: configuration) {
			return layout
		}

		let layout = OldTextLayout(configuration: configuration)
		Cache.instance.add(layout)

		return layout
	}


	internal var numberOfLines: Int {
		return result.numberOfLines
	}


	func rect(forLine line: Int) -> CGRect {
		guard (0 ..< numberOfLines).contains(line) else {
			fatalError("Line index \(line) is out of range 0 ..< \(numberOfLines)")
		}

		let origin = result.origin

		var currentLine = 0
		var rect = CGRect.null

		result.layoutManager.enumerateLineFragments(forGlyphRange: result.glyphRange) { _, usedRect, _, _, stop in
			if currentLine == line {
				rect = usedRect
				rect.left += origin.left
				rect.top += origin.top

				stop.pointee = true
			}

			currentLine += 1
		}

		return rect
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


	internal var size: CGSize {
		return result.size
	}



	// FIXME cache purging - we shouldn't grow the cache forever
	private struct Cache {

		static var instance = Cache()

		private var layouts = [OldTextLayout]()


		private init() {}


		mutating func add(_ layout: OldTextLayout) {
			// TODO possible optimization: drop other layouts which are also covered by this layout (happens when maxSize/NumberOfLines increases in subsequent layout geenrations)
			layouts.append(layout)
		}


		func get(for configuration: Configuration) -> OldTextLayout? {
			return layouts.first { layout($0, isAcceptableFor: configuration) }
		}


		private func layout(_ layout: OldTextLayout, isAcceptableFor configuration: Configuration) -> Bool {
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
			guard configuration.highPrecision == layout.configuration.highPrecision else {
				// different measuring will result in a different layout
				return false
			}

			guard configuration.maximumNumberOfLines >= layout.numberOfLines else {
				// allowing less lines than were already laid out will result in a different layout
				return false
			}
			guard !layout.result.isTruncated || configuration.maximumNumberOfLines == layout.numberOfLines || layout.configuration.maximumNumberOfLines > layout.numberOfLines else {
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

		var highPrecision: Bool
		var lineBreakMode: NSLineBreakMode
		var maximumNumberOfLines: Int
		var maximumSize: CGSize
		var minimumScaleFactor: CGFloat
		var renderingScale: CGFloat
		var text: NSAttributedString


		fileprivate init(
			highPrecision: Bool,
			lineBreakMode: NSLineBreakMode,
			maximumNumberOfLines: Int,
			maximumSize: CGSize,
			minimumScaleFactor: CGFloat,
			renderingScale: CGFloat,
			text: NSAttributedString
		) {
			self.highPrecision = highPrecision
			self.lineBreakMode = lineBreakMode
			self.maximumNumberOfLines = maximumNumberOfLines
			self.maximumSize = maximumSize
			self.minimumScaleFactor = minimumScaleFactor
			self.renderingScale = renderingScale
			self.text = text
		}


		var debugDescription: String {
			return "OldTextLayout.Configuration(lineBreakMode: \(lineBreakMode), maximumNumberOfLines: \(maximumNumberOfLines == Int.max ? "-" : String(maximumNumberOfLines)), maximumSize: \(maximumSize), minimumScaleFactor: \(minimumScaleFactor), renderingScale: \(renderingScale), text: '\(text.string)', highPrecision: \(highPrecision))"
		}
	}



	private struct Layouter {

		private let _debuggingFix = 0 // https://bugs.swift.org/browse/SR-4204


		private init() {}


		static func layout(configuration: Configuration) -> Result {
			// Since TextKit doesn't give us the right hooks to make our layout work we have to perform multiple layout cycles in order to measure the
			// correct fitting size which excludes any space below the last line's baseline and any space above capital letters of the largest font of first
			// line. We start with more available height than necessary which must be larger than the spacing to be compensated for. It should be as small
			// as possible though in order to prevent an unnecessary high number of layout cycles, each reducing the available height further.
			return Layouter().layout(configuration: configuration, textContainerHeight: configuration.maximumSize.height + 100) // FIXME use better approximation
		}


		private func layout(configuration: Configuration, textContainerHeight: CGFloat, iteration: Int = 1) -> Result {
			let textContainerSize = CGSize(width: configuration.maximumSize.width, height: textContainerHeight)
				.scale(by: 1 / configuration.minimumScaleFactor)

			let textContainer = NSTextContainer(size: textContainerSize)
			textContainer.lineBreakMode = configuration.lineBreakMode
			textContainer.lineFragmentPadding = 0
			textContainer.maximumNumberOfLines = configuration.maximumNumberOfLines == Int.max ? 0 : configuration.maximumNumberOfLines

			let layoutManager = LayoutManager()
			layoutManager.usesFontLeading = true
			layoutManager.addTextContainer(textContainer)

			let textStorage = NSTextStorage(attributedString: configuration.text)
			textStorage.addLayoutManager(layoutManager)

			layoutManager.ensureLayout(for: textContainer)

			let string = textStorage.string
			var size = CGSize.zero

			// Measure total size while taking head & tail indents into account.
			do {
				var paragraphStyle = NSParagraphStyle()
				var paragraphStyleEndIndex = Int.max
				var isFirstLineOfParagraph = true
				var lastLineUsedRectBottom = CGFloat(0)

				layoutManager.enumerateLineFragments(forGlyphRange: layoutManager.glyphRange(forBoundingRect: layoutManager.usedRect(for: textContainer), in: textContainer)) { _, usedRectForLine, _, glyphRangeForLine, stop in
					let spacingToPreviousLine = usedRectForLine.top - lastLineUsedRectBottom
					let characterRangeForLine = layoutManager.characterRange(forGlyphRange: glyphRangeForLine, actualGlyphRange: nil)

					if isFirstLineOfParagraph, let lineParagraphStyle = textStorage.attribute(.paragraphStyle, at: characterRangeForLine.location, effectiveRange: nil) as? NSParagraphStyle {
						paragraphStyle = lineParagraphStyle
						paragraphStyleEndIndex = characterRangeForLine.endLocation
					}
					else if characterRangeForLine.location >= paragraphStyleEndIndex {
						paragraphStyle = NSParagraphStyle()
					}

					let headIndent = isFirstLineOfParagraph ? paragraphStyle.firstLineHeadIndent : paragraphStyle.headIndent
					let tailIndent = paragraphStyle.tailIndent

					var lineWidth = usedRectForLine.width
					if tailIndent > 0 {
						lineWidth = lineWidth.coerced(atLeast: tailIndent)
					}
					else {
						lineWidth -= tailIndent
					}
					lineWidth += headIndent

					size.width = size.width.coerced(atLeast: lineWidth)
					size.height += spacingToPreviousLine
					size.height += usedRectForLine.height

					if size.height >= configuration.maximumSize.height {
						stop.pointee = true
						return
					}

					if glyphRangeForLine.length > 0,
						let characterRangeForLine = characterRangeForLine.rangeInString(string),
						let lastCharacter = string[characterRangeForLine].unicodeScalars.last
					{
						isFirstLineOfParagraph = CharacterSet.newlines.contains(lastCharacter)
					}

					lastLineUsedRectBottom = usedRectForLine.bottom
				}
			}

			size.width = size.width.coerced(atMost: textContainerSize.width)

			// compensate for rounding errors which can cause an unexpected truncation
			size.width += 0.01
			size.height += 0.01

			textContainer.size = size
			layoutManager.ensureLayout(for: textContainer)

			// Figure out which glyphs fitted in our text contained and were laid out. This range may also include glyphs which are not visible due to
			// layoutManager.glyphRange(forBoundingRect:in:) not being reliable or due to text being truncated in the middle.
			var visibleGlyphRange = layoutManager.glyphRange(forBoundingRect: CGRect(size: size), in: textContainer)
			guard visibleGlyphRange.length > 0 else {
				return Result(
					contentInsets:      .zero,
					dependsOnTintColor: false,
					glyphRange:         .notFound,
					isTruncated:        !string.isEmpty,
					layoutManager:      layoutManager,
					numberOfLines:      0,
					origin:             .zero,
					scaleFactor:        1,
					size:               .zero,
					textContainer:      textContainer,
					textStorage:        textStorage
				)
			}

			// How many lines did we manage to lay out?
			var numberOfLines = 0
			layoutManager.enumerateLineFragments(forGlyphRange: visibleGlyphRange) { _, _, _, _, _ in numberOfLines += 1 }
			assert(numberOfLines <= configuration.maximumNumberOfLines)

			// layoutManager's bounding rectangles aren't calculated correctly unless we declare glyph drawing outside of the line fragments.
			// Try it without this when using the font Zapfino if you don't belive me.
			for glyphIndex in visibleGlyphRange {
				layoutManager.setDrawsOutsideLineFragment(true, forGlyphAt: glyphIndex)
			}

			// Union of all lines' bounding rect.
			var boundingRect = CGRect.null

			// Union of all lines' used rect.
			var usedRect = CGRect.null

			// If configuration.usesHighPrecision is true then this is the distance between first line's upper end and the tallest capital letter of all fonts
			// of the first line. 0 otherwise.
			var topSpacingToRemove = CGFloat(0)

			// If configuration.usesHighPrecision is true then this is the distance between last line's baseline and it's lower end. 0 otherwise.
			var bottomSpacingToRemove = CGFloat(0)

			// First try to figure out if text was truncated or not.
			var isTruncated = visibleGlyphRange.endLocation < layoutManager.numberOfGlyphs

			var lineIndex = 0
			layoutManager.enumerateLineFragments(forGlyphRange: visibleGlyphRange) { rectForLine, usedRectForLine, _, glyphRangeForLine, _ in
				let isFirstLine = lineIndex == 0
				let isLastLine = lineIndex == (numberOfLines - 1)
				let characterRangeForLine = layoutManager.characterRange(forGlyphRange: glyphRangeForLine, actualGlyphRange: nil)
				var usedRectForLine = usedRectForLine

				// layoutManager.boundingRect(forGlyphRange:in:) is unreliable when the range ends with a newline character, but we can simply shorten it.
				var glyphRangeForLineBoundingRect = glyphRangeForLine
				if glyphRangeForLine.length > 0,
					let characterRangeForLine = characterRangeForLine.rangeInString(string),
					let lastCharacter = string[characterRangeForLine].unicodeScalars.last,
					CharacterSet.newlines.contains(lastCharacter)
				{
					glyphRangeForLineBoundingRect.length -= 1
				}

				if glyphRangeForLineBoundingRect.length > 0 && characterRangeForLine.length > 0 {
					// Form union of line's bounding rectangle with one's of the other lines.
					let boundingRectForLine = layoutManager.boundingRect(forGlyphRange: glyphRangeForLineBoundingRect, in: textContainer)
					boundingRect = boundingRect.union(boundingRectForLine)

					// This is why we do all this. We'd like to strip the whitespace between the upper end of labels and the capital letters of the first line
					// as well as between the last line's baseline and the lower end of the label.
					if configuration.highPrecision {
						if isFirstLine || isLastLine {
							if let capitalLetterSpacing = textStorage.capitalLetterSpacing(in: characterRangeForLine, forLineHeight: usedRectForLine.height, usingFontLeading: layoutManager.usesFontLeading) {
								if isFirstLine {
									topSpacingToRemove = capitalLetterSpacing.above
								}
								if isLastLine {
									bottomSpacingToRemove = capitalLetterSpacing.below
								}
							}
						}
					}
				}

				// Check if text was truncated not just at the end but somewhere else, e.g. by .byTruncatingHead or .byTruncatingMiddle.
				// Note that layoutManager.truncatedGlyphRange(inLineFragmentForGlyphAt:) is very unreliable here and often returns NSNotFound even if the text
				// was truncated.
				if !isTruncated {
					let truncatedGlyphRange = layoutManager.truncatedGlyphRange(inLineFragmentForGlyphAt: glyphRangeForLine.location)
					if truncatedGlyphRange.length > 0 {
						isTruncated = true
					}
				}

				// Remove trailing whitespace from last line to reflect UILabel's default behavior.
				// Not necessary if truncation happend since in that case NSLayoutManager will do that on its own…
				// TODO in order for this to work this must be done between the first and second layout pass
				if isLastLine && !isTruncated && characterRangeForLine.length > 0, let stringRangeForLine = characterRangeForLine.rangeInString(string) {
					let stringForLine = string[stringRangeForLine]
					let charactersToRemoveFromEndOfLine = CharacterSet.whitespacesAndNewlines

					var strippedCharacterRangeForLine = characterRangeForLine
					for character in stringForLine.unicodeScalars.reversed() {
						guard charactersToRemoveFromEndOfLine.contains(character) else {
							break
						}

						strippedCharacterRangeForLine.length -= 1
					}

					if strippedCharacterRangeForLine.length < characterRangeForLine.length {
						let strippedGlyphRangeForLine = layoutManager.glyphRange(forCharacterRange: strippedCharacterRangeForLine, actualCharacterRange: nil).clamped(to: glyphRangeForLine)
						if strippedGlyphRangeForLine != glyphRangeForLine {
							if strippedCharacterRangeForLine.length > 0 {
								layoutManager.enumerateEnclosingRects(forGlyphRange: NSRange(location: strippedCharacterRangeForLine.endLocation - 1, length: 1), withinSelectedGlyphRange: .notFound, in: textContainer) { glyphRect, _ in
									usedRectForLine.widthFromLeft = glyphRect.right - usedRectForLine.left
								}
							}
							else {
								usedRectForLine.widthFromLeft = 0
							}

							layoutManager.setLineFragmentRect(rectForLine, forGlyphRange: glyphRangeForLine, usedRect: usedRectForLine)
							visibleGlyphRange = NSRange(location: visibleGlyphRange.location, length: strippedGlyphRangeForLine.endLocation - visibleGlyphRange.location)
						}
					}
				}

				// Form union of line's used rectangle with one's of the other lines.
				usedRect = usedRect.union(usedRectForLine)

				lineIndex += 1
			}

			assert(!boundingRect.isNull)
			assert(!usedRect.isNull)

			let visibleCharacterRange = layoutManager.characterRange(forGlyphRange: visibleGlyphRange, actualGlyphRange: nil)

			// Check whether the visible text depends on the tint color. Enables optimizations where clients of the OldTextLayout can prevent unecessary redraws
			// when the tint color changes.
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

			// If scaling is allowed, figure out how much we had to scale in order to make the text fit.
			let scaleFactor: CGFloat
			if configuration.minimumScaleFactor < 1 {
				scaleFactor = min(configuration.maximumSize.width / usedRect.width, configuration.maximumSize.height / usedRect.height).coerced(atMost: 1)
				if scaleFactor < 1 {
					boundingRect.left *= scaleFactor
					boundingRect.top *= scaleFactor
					boundingRect.size = boundingRect.size.scale(by: scaleFactor)

					usedRect.left *= scaleFactor
					usedRect.top *= scaleFactor
					usedRect.size = usedRect.size.scale(by: scaleFactor)

					topSpacingToRemove *= scaleFactor
					bottomSpacingToRemove *= scaleFactor
				}
			}
			else {
				scaleFactor = 1
			}

			// Align everything nicely depending on our renderingScale in order to prevent unwanted subpixel drawing.
			let gridIncrement = 1 / configuration.renderingScale

			topSpacingToRemove = OldTextLayout.roundDownIgnoringErrors(topSpacingToRemove, increment: gridIncrement)
			bottomSpacingToRemove = OldTextLayout.roundDownIgnoringErrors(bottomSpacingToRemove, increment: gridIncrement)

			boundingRect.left = OldTextLayout.roundDownIgnoringErrors(boundingRect.left, increment: gridIncrement)
			boundingRect.top = OldTextLayout.roundDownIgnoringErrors(boundingRect.top, increment: gridIncrement)
			boundingRect.widthFromLeft = OldTextLayout.roundUpIgnoringErrors(boundingRect.width, increment: gridIncrement)
			boundingRect.heightFromTop = OldTextLayout.roundUpIgnoringErrors(boundingRect.height, increment: gridIncrement)

			usedRect.heightFromTop = OldTextLayout.roundUpIgnoringErrors(usedRect.height, increment: gridIncrement)
			usedRect.widthFromLeft = OldTextLayout.roundUpIgnoringErrors(usedRect.width, increment: gridIncrement)

			// If the text we've laid out is longer than allowed then we'll have to try again with a shorter text container.
			// This is necessary since we don't have access to typesetting and cannot tell NSLayoutManager to allow the `topSpacingToRemove` and
			// `bottomSpacingToRemove` to lie outside of the text container.
			if usedRect.height > configuration.maximumSize.height && usedRect.height < textContainerSize.height {
				if iteration < OldTextLayout.maximumLayoutIterationCount {
					return layout(configuration: configuration, textContainerHeight: usedRect.height, iteration: iteration + 1)
				}

				log("OldTextLayout needs too many iterations. Implementation may be broken:")
				log("Configuration: \(configuration)")
				assertionFailure("OldTextLayout needs too many iterations. Implementation may be broken.")
			}

			size.height -= topSpacingToRemove
			size.height -= bottomSpacingToRemove

			let contentInsets = UIEdgeInsets(fromRect: CGRect(size: size), toRect: boundingRect)
			let origin = CGPoint(left: -boundingRect.left, top: -boundingRect.top - topSpacingToRemove)

			return Result(
				contentInsets:      contentInsets,
				dependsOnTintColor: dependsOnTintColor,
				glyphRange:         visibleGlyphRange,
				isTruncated:        isTruncated,
				layoutManager:      layoutManager,
				numberOfLines:      numberOfLines,
				origin:             origin,
				scaleFactor:        scaleFactor,
				size:               size,
				textContainer:      textContainer,
				textStorage:        textStorage
			)
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


		func draw(layout: OldTextLayout, in context: CGContext, defaultTextColor: UIColor, tintColor: UIColor) {
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

			self.defaultTextColor = defaultTextColor.tinted(with: tintColor)
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

		var contentInsets: UIEdgeInsets
		var dependsOnTintColor: Bool
		var glyphRange: NSRange
		var isTruncated: Bool
		var layoutManager: NSLayoutManager
		var numberOfLines: Int
		var origin: CGPoint
		var scaleFactor: CGFloat
		var size: CGSize
		var textContainer: NSTextContainer
		var textStorage: NSTextStorage // NSLayoutManager only maintains a weak reference
	}
}


@objc(_JetPack_UI_OldTextLayout_Initialization)
private class StaticInitialization: NSObject, StaticInitializable {

	static func staticInitialize() {
		let defaultLinkAttributesSelector = obfuscatedSelector("_", "default", "Link", "Attributes")
		copyMethod(selector: defaultLinkAttributesSelector, from: object_getClass(NSLayoutManager.self)!, to: object_getClass(OldTextLayout.LayoutManager.self)!)
		swizzleMethod(in: object_getClass(OldTextLayout.LayoutManager.self)!, from: #selector(getter: OldTextLayout.LayoutManager.linkAttributes), to: defaultLinkAttributesSelector)
	}
}

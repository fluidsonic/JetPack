import UIKit


public struct PartialParagraphStyle {

	public var alignment: TextAlignment.Horizontal?
	public var allowsDefaultTighteningForTruncation: Bool?
	public var baseWritingDirection: NSWritingDirection?
	public var defaultTabInterval: CGFloat?
	public var firstLineHeadIndent: CGFloat?
	public var headIndent: CGFloat?
	public var hyphenationFactor: Float?
	public var lineBreakMode: NSLineBreakMode?
	public var lineHeight: TextLineHeight?
	public var lineSpacing: CGFloat?
	public var maximumLineHeight: CGFloat?
	public var minimumLineHeight: CGFloat?
	public var paragraphSpacing: CGFloat?
	public var paragraphSpacingBefore: CGFloat?
	public var tabStops: [NSTextTab]?
	public var tailIndent: CGFloat?


	public init(
		alignment: TextAlignment.Horizontal? = nil,
		allowsDefaultTighteningForTruncation: Bool? = nil,
		baseWritingDirection: NSWritingDirection? = nil,
		defaultTabInterval: CGFloat? = nil,
		firstLineHeadIndent: CGFloat? = nil,
		headIndent: CGFloat? = nil,
		hyphenationFactor: Float? = nil,
		lineBreakMode: NSLineBreakMode? = nil,
		lineHeight: TextLineHeight? = nil,
		lineSpacing: CGFloat? = nil,
		maximumLineHeight: CGFloat? = nil,
		minimumLineHeight: CGFloat? = nil,
		paragraphSpacing: CGFloat? = nil,
		paragraphSpacingBefore: CGFloat? = nil,
		tabStops: [NSTextTab]? = nil,
		tailIndent: CGFloat? = nil
	) {
		self.alignment = alignment
		self.allowsDefaultTighteningForTruncation = allowsDefaultTighteningForTruncation
		self.baseWritingDirection = baseWritingDirection
		self.defaultTabInterval = defaultTabInterval
		self.firstLineHeadIndent = firstLineHeadIndent
		self.headIndent = headIndent
		self.hyphenationFactor = hyphenationFactor
		self.lineBreakMode = lineBreakMode
		self.lineHeight = lineHeight
		self.lineSpacing = lineSpacing
		self.maximumLineHeight = maximumLineHeight
		self.minimumLineHeight = minimumLineHeight
		self.paragraphSpacing = paragraphSpacing
		self.paragraphSpacingBefore = paragraphSpacingBefore
		self.tabStops = tabStops
		self.tailIndent = tailIndent
	}


	mutating func apply(_ partialStyle: PartialParagraphStyle) {
		if let alignment = partialStyle.alignment {
			self.alignment = alignment
		}
		if let allowsDefaultTighteningForTruncation = partialStyle.allowsDefaultTighteningForTruncation {
			self.allowsDefaultTighteningForTruncation = allowsDefaultTighteningForTruncation
		}
		if let baseWritingDirection = partialStyle.baseWritingDirection {
			self.baseWritingDirection = baseWritingDirection
		}
		if let defaultTabInterval = partialStyle.defaultTabInterval {
			self.defaultTabInterval = defaultTabInterval
		}
		if let firstLineHeadIndent = partialStyle.firstLineHeadIndent {
			self.firstLineHeadIndent = firstLineHeadIndent
		}
		if let headIndent = partialStyle.headIndent {
			self.headIndent = headIndent
		}
		if let hyphenationFactor = partialStyle.hyphenationFactor {
			self.hyphenationFactor = hyphenationFactor
		}
		if let lineBreakMode = partialStyle.lineBreakMode {
			self.lineBreakMode = lineBreakMode
		}
		if let lineHeight = partialStyle.lineHeight {
			self.lineHeight = lineHeight
		}
		if let maximumLineHeight = partialStyle.maximumLineHeight {
			self.maximumLineHeight = maximumLineHeight
		}
		if let minimumLineHeight = partialStyle.minimumLineHeight {
			self.minimumLineHeight = minimumLineHeight
		}
		if let paragraphSpacing = partialStyle.paragraphSpacing {
			self.paragraphSpacing = paragraphSpacing
		}
		if let paragraphSpacingBefore = partialStyle.paragraphSpacingBefore {
			self.paragraphSpacingBefore = paragraphSpacingBefore
		}
		if let tabStops = partialStyle.tabStops {
			self.tabStops = tabStops
		}
		if let tailIndent = partialStyle.tailIndent {
			self.tailIndent = tailIndent
		}
	}
}


extension NSAttributedString.Key {

	public static let partialParagraphStyle = NSAttributedString.Key("partialParagraphStyle")
}


extension NSMutableParagraphStyle {

	func apply(_ partialStyle: PartialParagraphStyle, using font: UIFont) {
		if let alignment = partialStyle.alignment {
			self.alignment = alignment
		}
		if let allowsDefaultTighteningForTruncation = partialStyle.allowsDefaultTighteningForTruncation {
			self.allowsDefaultTighteningForTruncation = allowsDefaultTighteningForTruncation
		}
		if let baseWritingDirection = partialStyle.baseWritingDirection {
			self.baseWritingDirection = baseWritingDirection
		}
		if let defaultTabInterval = partialStyle.defaultTabInterval {
			self.defaultTabInterval = defaultTabInterval
		}
		if let firstLineHeadIndent = partialStyle.firstLineHeadIndent {
			self.firstLineHeadIndent = firstLineHeadIndent
		}
		if let headIndent = partialStyle.headIndent {
			self.headIndent = headIndent
		}
		if let hyphenationFactor = partialStyle.hyphenationFactor {
			self.hyphenationFactor = hyphenationFactor
		}
		if let lineBreakMode = partialStyle.lineBreakMode {
			self.lineBreakMode = lineBreakMode
		}
		if let lineHeight = partialStyle.lineHeight {
			if case .absolute = lineHeight {
				set(lineHeight: lineHeight, with: font)

				if let maximumLineHeight = partialStyle.maximumLineHeight {
					self.maximumLineHeight = min(maximumLineHeight, self.maximumLineHeight)
				}
				if let minimumLineHeight = partialStyle.minimumLineHeight {
					self.minimumLineHeight = max(minimumLineHeight, self.minimumLineHeight)
				}
			}
			else {
				set(lineHeight: lineHeight, with: font)
			}
		}
		else {
			if let maximumLineHeight = partialStyle.maximumLineHeight {
				self.maximumLineHeight = maximumLineHeight
			}
			if let minimumLineHeight = partialStyle.minimumLineHeight {
				self.minimumLineHeight = minimumLineHeight
			}
		}
		if let paragraphSpacing = partialStyle.paragraphSpacing {
			self.paragraphSpacing = paragraphSpacing
		}
		if let paragraphSpacingBefore = partialStyle.paragraphSpacingBefore {
			self.paragraphSpacingBefore = paragraphSpacingBefore
		}
		if let tabStops = partialStyle.tabStops {
			self.tabStops = tabStops
		}
		if let tailIndent = partialStyle.tailIndent {
			self.tailIndent = tailIndent
		}
	}
}

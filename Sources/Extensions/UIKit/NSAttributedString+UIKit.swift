import UIKit


extension NSAttributedString {

	public func capitalLetterSpacing(in range: NSRange, forLineHeight lineHeight: CGFloat? = nil) -> CapitalLetterSpacing? {
		var smallestSpacingAboveCapitalLetters: CGFloat?
		var largestSpacingBelowCapitalLetters: CGFloat?

		enumerateAttributes(in: range, options: .longestEffectiveRangeNotRequired) { attributes,	_, _ in
			guard let font = attributes[NSFontAttributeName] as? UIFont else {
				return
			}

			let effectiveLineHeight: CGFloat
			if let lineHeight = lineHeight {
				effectiveLineHeight = lineHeight
			}
			else if let paragraphStyle = attributes[NSParagraphStyleAttributeName] as? NSParagraphStyle {
				effectiveLineHeight = paragraphStyle.effectiveLineHeight(for: font.lineHeight)
			}
			else {
				effectiveLineHeight = font.lineHeight
			}

			let spacingAboveCapitalLetters = effectiveLineHeight - font.capHeight + font.descender
			let spacingBelowCapitalLetters = -font.descender

			smallestSpacingAboveCapitalLetters = optionalMin(smallestSpacingAboveCapitalLetters, spacingAboveCapitalLetters)
			largestSpacingBelowCapitalLetters = optionalMax(largestSpacingBelowCapitalLetters, spacingBelowCapitalLetters)
		}

		if let smallestSpacingAboveCapitalLetters = smallestSpacingAboveCapitalLetters, let smallestSpacingBelowCapitalLetters = largestSpacingBelowCapitalLetters {
			return CapitalLetterSpacing(above: smallestSpacingAboveCapitalLetters, below: smallestSpacingBelowCapitalLetters)
		}
		else {
			return nil
		}
	}



	public struct CapitalLetterSpacing {

		public var above: CGFloat
		public var below: CGFloat


		public init(above: CGFloat, below: CGFloat) {
			self.above = above
			self.below = below
		}
	}
}

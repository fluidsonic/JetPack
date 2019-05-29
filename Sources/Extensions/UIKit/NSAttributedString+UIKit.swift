import UIKit


extension NSAttributedString {

	@nonobjc
	func capitalLetterSpacing(in range: NSRange, forLineHeight lineHeight: CGFloat? = nil, usingFontLeading: Bool = true) -> CapitalLetterSpacing? {
		var smallestSpacingAboveCapitalLetters: CGFloat?
		var smallestSpacingBelowCapitalLetters: CGFloat?

		enumerateAttributes(in: range, options: .longestEffectiveRangeNotRequired) { attributes, _, _ in
			guard let font = attributes[.font] as? UIFont else {
				return
			}

			var effectiveLineHeight: CGFloat
			if let lineHeight = lineHeight {
				effectiveLineHeight = lineHeight - (usingFontLeading ? font.leading : 0)
			}
			else if let paragraphStyle = attributes[.paragraphStyle] as? NSParagraphStyle {
				effectiveLineHeight = paragraphStyle.effectiveLineHeight(for: font.lineHeight)
			}
			else {
				effectiveLineHeight = font.lineHeight
			}

			let spacingAboveCapitalLetters = (effectiveLineHeight - font.capHeight + font.descender).coerced(atLeast: 0)
			let spacingBelowCapitalLetters = -font.descender

			smallestSpacingAboveCapitalLetters = optionalMin(smallestSpacingAboveCapitalLetters, spacingAboveCapitalLetters)
			smallestSpacingBelowCapitalLetters = optionalMin(smallestSpacingBelowCapitalLetters, spacingBelowCapitalLetters)
		}

		if
			let smallestSpacingAboveCapitalLetters = smallestSpacingAboveCapitalLetters,
			let smallestSpacingBelowCapitalLetters = smallestSpacingBelowCapitalLetters
		{
			return CapitalLetterSpacing(above: smallestSpacingAboveCapitalLetters, below: smallestSpacingBelowCapitalLetters)
		}
		else {
			return nil
		}
	}



	struct CapitalLetterSpacing {

		var above: CGFloat
		var below: CGFloat


		init(above: CGFloat, below: CGFloat) {
			self.above = above
			self.below = below
		}
	}
}

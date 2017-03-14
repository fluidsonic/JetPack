import UIKit


extension NSAttributedString {

	@nonobjc
	public func capitalLetterSpacing(in range: NSRange, forLineHeight lineHeight: CGFloat? = nil, usingFontLeading: Bool = true) -> CapitalLetterSpacing? {
		var smallestSpacingAboveCapitalLetters: CGFloat?
		var largestSpacingBelowCapitalLetters: CGFloat?

		enumerateAttributes(in: range, options: .longestEffectiveRangeNotRequired) { attributes, _, _ in
			guard let font = attributes[NSFontAttributeName] as? UIFont else {
				return
			}

			var effectiveLineHeight: CGFloat
			if let lineHeight = lineHeight {
				effectiveLineHeight = lineHeight - (usingFontLeading ? font.leading : 0)
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


	@nonobjc
	public func withDefaultAttributes(
		font: UIFont? = nil,
		foregroundColor: UIColor? = nil,
		kerning: TextKerning? = nil,
		paragraphStyle: NSParagraphStyle? = nil,
		transform: TextTransform? = nil
	) -> NSMutableAttributedString {
		var defaultAttributes = [String : Any]()
		if let font = font {
			defaultAttributes[NSFontAttributeName] = font
		}
		if let foregroundColor = foregroundColor {
			defaultAttributes[NSForegroundColorAttributeName] = foregroundColor
		}
		if let paragraphStyle = paragraphStyle {
			defaultAttributes[NSParagraphStyleAttributeName] = paragraphStyle
		}

		let attributedString = NSMutableAttributedString(string: string, attributes: defaultAttributes)
		attributedString.edit {
			enumerateAttributes(in: NSRange(forString: string), options: .longestEffectiveRangeNotRequired) { attributes, range, _ in
				var attributes = attributes

				if let kerning = kerning {
					let font = attributes[NSFontAttributeName] as? UIFont ?? font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)

					attributes[NSKernAttributeName] = kerning.forFontSize(font.pointSize) as NSNumber
				}

				attributedString.addAttributes(attributes, range: range)
			}

			if let transform = transform {
				let transformation: (String) -> String
				switch transform {
				case .capitalize: transformation = { $0.localizedCapitalized } // TODO this isn't 100% reliable when applying to segments instead of to the whole string
				case .lowercase:  transformation = { $0.localizedLowercase }
				case .uppercase:  transformation = { $0.localizedUppercase }
				}

				attributedString.transformStringSegments(transformation)
			}
		}
		
		return attributedString
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

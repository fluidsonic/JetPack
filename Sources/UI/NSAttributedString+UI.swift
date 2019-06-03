import UIKit


extension NSAttributedString {

	@nonobjc
	func withDefaultAttributes(
		font defaultFont: UIFont,
		letterSpacing defaultLetterSpacing: TextLetterSpacing?,
		paragraphStyle defaultParagraphStyle: PartialParagraphStyle,
		transform: TextTransform?
	) -> NSMutableAttributedString {
		var defaultAttributes = [NSAttributedString.Key : Any]()
		defaultAttributes[.font] = defaultFont

		let attributedString = NSMutableAttributedString(string: string, attributes: defaultAttributes)
		attributedString.edit {
			enumerateAttributes(in: NSRange(location: 0, length: length), options: .longestEffectiveRangeNotRequired) { attributes, range, _ in
				var attributes = attributes
				let font = attributes[.font] as? UIFont ?? defaultFont

				if let defaultLetterSpacing = defaultLetterSpacing, attributes[.kern] == nil {
					attributes[.kern] = defaultLetterSpacing.at(fontSize: font.pointSize)
				}

				var partialParagraphStyle = defaultParagraphStyle
				if let additionalParagraphStyle = attributes[.partialParagraphStyle] as? PartialParagraphStyle {
					partialParagraphStyle.apply(additionalParagraphStyle)
					attributes[.partialParagraphStyle] = nil
				}

				let paragraphStyle = (attributes[.paragraphStyle] as? NSParagraphStyle)?.mutableCopy() as! NSMutableParagraphStyle? ?? NSMutableParagraphStyle()
				paragraphStyle.apply(partialParagraphStyle, using: font)
				attributes[.paragraphStyle] = paragraphStyle

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
}

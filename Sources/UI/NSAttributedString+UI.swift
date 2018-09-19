import UIKit


extension NSAttributedString {

	@nonobjc
	public func withDefaultAttributes(
		font: UIFont? = nil,
		foregroundColor: UIColor? = nil,
		kerning: TextKerning? = nil,
		paragraphStyle: NSParagraphStyle? = nil,
		transform: TextTransform? = nil
	) -> NSMutableAttributedString {
		var defaultAttributes = [NSAttributedString.Key : Any]()
		if let font = font {
			defaultAttributes[.font] = font
		}
		if let foregroundColor = foregroundColor {
			defaultAttributes[.foregroundColor] = foregroundColor
		}
		if let paragraphStyle = paragraphStyle {
			defaultAttributes[.paragraphStyle] = paragraphStyle
		}

		let attributedString = NSMutableAttributedString(string: string, attributes: defaultAttributes)
		attributedString.edit {
			enumerateAttributes(in: NSRange(location: 0, length: length), options: .longestEffectiveRangeNotRequired) { attributes, range, _ in
				var attributes = attributes

				if let kerning = kerning {
					let font = attributes[.font] as? UIFont ?? font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)

					attributes[.kern] = kerning.forFontSize(font.pointSize) as NSNumber
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
}

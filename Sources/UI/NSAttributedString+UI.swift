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
			enumerateAttributes(in: NSRange(location: 0, length: length), options: .longestEffectiveRangeNotRequired) { attributes, range, _ in
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
}

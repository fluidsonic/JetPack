import UIKit


extension NSAttributedString {

	@nonobjc
	func maximumFontSize(in range: NSRange) -> CGFloat? {
		var maximumFontSize: CGFloat?

		enumerateAttributes(in: range, options: .longestEffectiveRangeNotRequired) { attributes, _, _ in
			guard let font = attributes[.font] as? UIFont else {
				return
			}

			maximumFontSize = optionalMin(maximumFontSize, font.pointSize)
		}

		return maximumFontSize
	}


	@nonobjc
	func withDefaultAttributes(
		font: UIFont? = nil,
		foregroundColor: UIColor? = nil,
		letterSpacing: TextLetterSpacing? = nil,
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

				if let letterSpacing = letterSpacing {
					let font = attributes[.font] as? UIFont ?? font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize) // TODO we can't resolve letter spacing here
					attributes[.kern] = letterSpacing.at(fontSize: font.pointSize) as NSNumber
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

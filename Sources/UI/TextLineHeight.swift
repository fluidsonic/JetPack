import CoreGraphics
import UIKit


public enum TextLineHeight: Equatable {

	case absolute(points: CGFloat)
	case fontDefault
	case relativeToFontLineHeight(multipler: CGFloat)
	case relativeToFontSize(multipler: CGFloat)


	public func with(font: UIFont) -> CGFloat {
		switch self {
		case let .absolute(points):                     return points
		case .fontDefault:                              return font.lineHeight
		case let .relativeToFontLineHeight(multiplier): return (font.lineHeight * multiplier)
		case let .relativeToFontSize(multiplier):       return (font.pointSize * multiplier)
		}
	}
}



public extension NSParagraphStyle {

	func lineHeight(with font: UIFont) -> TextLineHeight {
		let maximumLineHeight = self.maximumLineHeight
		if maximumLineHeight > 0 && maximumLineHeight == minimumLineHeight {
			return .absolute(points: maximumLineHeight)
		}

		let lineHeightMultiple = self.lineHeightMultiple
		if lineHeightMultiple == 0 {
			return .fontDefault
		}

		return .relativeToFontSize(multipler: lineHeightMultiple / font.lineHeight * font.pointSize)
	}
}


public extension NSMutableParagraphStyle {

	func set(lineHeight: TextLineHeight, with font: UIFont) {
		switch lineHeight {
		case let .absolute(points):
			maximumLineHeight = points
			minimumLineHeight = points
			lineHeightMultiple = 0

		case .fontDefault:
			maximumLineHeight = 0
			minimumLineHeight = 0
			lineHeightMultiple = 0

		case let .relativeToFontLineHeight(multiplier):
			maximumLineHeight = 0
			minimumLineHeight = 0
			lineHeightMultiple = multiplier

		case let .relativeToFontSize(multiplier):
			maximumLineHeight = 0
			minimumLineHeight = 0
			lineHeightMultiple = (font.pointSize / font.lineHeight) * multiplier
		}
	}
}

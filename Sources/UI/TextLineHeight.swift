import CoreGraphics
import UIKit


public enum TextLineHeight: Equatable {

	case absolute(points: CGFloat)
	case fontDefault
	case relativeToFontSize(multipler: CGFloat)


	public func with(font: UIFont) -> CGFloat {
		switch self {
		case let .absolute(points):               return points
		case .fontDefault:                        return font.lineHeight
		case let .relativeToFontSize(multiplier): return (font.pointSize * multiplier)
		}
	}
}



extension NSParagraphStyle {

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


extension NSMutableParagraphStyle {

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

		case let .relativeToFontSize(multipler):
			maximumLineHeight = 0
			minimumLineHeight = 0
			lineHeightMultiple = multipler / font.lineHeight * font.pointSize
		}
	}
}

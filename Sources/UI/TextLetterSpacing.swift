import CoreGraphics


public enum TextLetterSpacing: Equatable {

	case absolute(points: CGFloat)
	case relativeToFontSize(multiplier: CGFloat)


	public func at(fontSize: CGFloat) -> CGFloat {
		switch self {
		case let .absolute(points):               return points
		case let .relativeToFontSize(multiplier): return fontSize * multiplier
		}
	}
}



@available(*, deprecated, renamed: "TextLetterSpacing")
public typealias TextKerning = TextLetterSpacing

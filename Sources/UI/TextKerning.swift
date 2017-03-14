import CoreGraphics


public enum TextKerning: Equatable {

	case absolute(points: CGFloat)
	case relativeToFontSize(multiplier: CGFloat)


	public func forFontSize(_ fontSize: CGFloat) -> CGFloat {
		switch self {
		case let .absolute(points):               return points
		case let .relativeToFontSize(multiplier): return fontSize * multiplier
		}
	}


	public static func == (a: TextKerning, b: TextKerning) -> Bool {
		switch (a, b) {
		case let (.absolute(a),           .absolute(b)):           return a == b
		case let (.relativeToFontSize(a), .relativeToFontSize(b)): return a == b
		default:                                                   return false
		}
	}
}


import CoreGraphics


public enum TextKerning: Equatable {

	case absolute(points: CGFloat)
	case relativeToFontSize(multiplier: CGFloat)


	public static func == (a: TextKerning, b: TextKerning) -> Bool {
		switch (a, b) {
		case let (.absolute(a),           .absolute(b)):           return a == b
		case let (.relativeToFontSize(a), .relativeToFontSize(b)): return a == b
		default:                                                   return false
		}
	}
}


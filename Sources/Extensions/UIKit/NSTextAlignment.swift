import UIKit


extension NSTextAlignment: CustomStringConvertible {

	public var description: String {
		switch self {
		case .Center:    return "center"
		case .Justified: return "justified"
		case .Left:      return "left"
		case .Natural:   return "natural"
		case .Right:     return "right"
		}
	}
}

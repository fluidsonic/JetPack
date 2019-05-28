import UIKit


extension NSTextAlignment: CustomStringConvertible {

	public var description: String {
		switch self {
		case .center:     return "center"
		case .justified:  return "justified"
		case .left:       return "left"
		case .natural:    return "natural"
		case .right:      return "right"
		@unknown default: return "rawValue(\(rawValue))"
		}
	}
}

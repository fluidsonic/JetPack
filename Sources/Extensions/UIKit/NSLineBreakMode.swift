import UIKit


extension NSLineBreakMode: CustomStringConvertible {

	public var description: String {
		switch self {
		case .byCharWrapping:     return ".byCharWrapping"
		case .byClipping:         return ".byClipping"
		case .byTruncatingHead:   return ".byTruncatingHead"
		case .byTruncatingMiddle: return ".byTruncatingMiddle"
		case .byTruncatingTail:   return ".byTruncatingTail"
		case .byWordWrapping:     return ".byWordWrapping"
		}
	}
}

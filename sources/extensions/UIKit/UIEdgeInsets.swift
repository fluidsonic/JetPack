import UIKit


public extension UIEdgeInsets {

	public static let zero = UIEdgeInsets()


	public init(all: CGFloat) {
		self.init(top: all, left: all, bottom: all, right: all)
	}


	public func insetRect(rect: CGRect) -> CGRect {
		return CGRect(
			left:   rect.left + left,
			top:    rect.top + top,
			width:  rect.width - left - right,
			height: rect.height - top - bottom
		).standardized
	}


	public var isEmpty: Bool {
		return (top == 0 && left == 0 && bottom == 0 && right == 0)
	}
}

import UIKit


public extension UIEdgeInsets {

	public static let zero = UIEdgeInsets()


	public init(all: CGFloat) {
		self.init(top: all, left: all, bottom: all, right: all)
	}


	public var isEmpty: Bool {
		return (top == 0 && left == 0 && bottom == 0 && right == 0)
	}
}



public extension CGRect {

	@warn_unused_result(mutable_variant="insetInPlace")
	public func insetBy(insets: UIEdgeInsets) -> CGRect {
		return CGRect(
			left:   left + insets.left,
			top:    top + insets.top,
			width:  width - insets.left - insets.right,
			height: height - insets.top - insets.bottom
			).standardized
	}


	public mutating func insetInPlace(insets: UIEdgeInsets) {
		self = insetBy(insets)
	}
}

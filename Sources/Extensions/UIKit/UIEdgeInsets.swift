import UIKit


public extension UIEdgeInsets {

	public init(all: CGFloat) {
		self.init(top: all, left: all, bottom: all, right: all)
	}


	public init(bottom: CGFloat) {
		self.init(top: 0, left: 0, bottom: bottom, right: 0)
	}


	public init(horizontal: CGFloat) {
		self.init(top: 0, left: horizontal, bottom: 0, right: horizontal)
	}


	public init(horizontal: CGFloat, vertical: CGFloat) {
		self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
	}


	public init(left: CGFloat) {
		self.init(top: 0, left: left, bottom: 0, right: 0)
	}


	public init(top: CGFloat) {
		self.init(top: top, left: 0, bottom: 0, right: 0)
	}


	public init(right: CGFloat) {
		self.init(top: 0, left: 0, bottom: 0, right: right)
	}


	public init(vertical: CGFloat) {
		self.init(top: vertical, left: 0, bottom: vertical, right: 0)
	}


	public init(fromRect: CGRect, toRect: CGRect) {
		self.init(
			top:    toRect.top - fromRect.top,
			left:   toRect.left - fromRect.left,
			bottom: fromRect.bottom - toRect.bottom,
			right:  fromRect.right - toRect.right
		)
	}


	
	public func increaseBy(_ insets: UIEdgeInsets) -> UIEdgeInsets {
		return UIEdgeInsets(top: top + insets.top, left: left + insets.left, bottom: bottom + insets.bottom, right: right + insets.right)
	}


	public mutating func increaseInPlace(_ insets: UIEdgeInsets) {
		self = increaseBy(insets)
	}


	public var inverse: UIEdgeInsets {
		return UIEdgeInsets(top: -top, left: -left, bottom: -bottom, right: -right)
	}


	public var isEmpty: Bool {
		return (top == 0 && left == 0 && bottom == 0 && right == 0)
	}
}



public extension CGRect {

	
	public func insetBy(_ insets: UIEdgeInsets) -> CGRect {
		return CGRect(
			left:   left + insets.left,
			top:    top + insets.top,
			width:  width - insets.left - insets.right,
			height: height - insets.top - insets.bottom
		)
	}


	public mutating func insetInPlace(_ insets: UIEdgeInsets) {
		self = insetBy(insets)
	}
}



public extension CGSize {

	
	public func insetBy(_ insets: UIEdgeInsets) -> CGSize {
		return CGSize(
			width:  width - insets.left - insets.right,
			height: height - insets.top - insets.bottom
		)
	}


	public mutating func insetInPlace(_ insets: UIEdgeInsets) {
		self = insetBy(insets)
	}
}

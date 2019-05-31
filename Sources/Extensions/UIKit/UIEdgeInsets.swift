import UIKit


public extension UIEdgeInsets {

	init(all: CGFloat) {
		self.init(top: all, left: all, bottom: all, right: all)
	}


	init(bottom: CGFloat) {
		self.init(top: 0, left: 0, bottom: bottom, right: 0)
	}


	init(horizontal: CGFloat) {
		self.init(top: 0, left: horizontal, bottom: 0, right: horizontal)
	}


	init(horizontal: CGFloat, vertical: CGFloat) {
		self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
	}


	init(left: CGFloat) {
		self.init(top: 0, left: left, bottom: 0, right: 0)
	}


	init(top: CGFloat) {
		self.init(top: top, left: 0, bottom: 0, right: 0)
	}


	init(right: CGFloat) {
		self.init(top: 0, left: 0, bottom: 0, right: right)
	}


	init(vertical: CGFloat) {
		self.init(top: vertical, left: 0, bottom: vertical, right: 0)
	}


	init(fromRect: CGRect, toRect: CGRect) {
		self.init(
			top:    toRect.top - fromRect.top,
			left:   toRect.left - fromRect.left,
			bottom: fromRect.bottom - toRect.bottom,
			right:  fromRect.right - toRect.right
		)
	}


	func copy(top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil) -> UIEdgeInsets {
		return UIEdgeInsets(top: top ?? self.top, left: left ?? self.left, bottom: bottom ?? self.bottom, right: right ?? self.right)
	}

	
	func increaseBy(_ insets: UIEdgeInsets) -> UIEdgeInsets {
		return UIEdgeInsets(top: top + insets.top, left: left + insets.left, bottom: bottom + insets.bottom, right: right + insets.right)
	}


	mutating func increaseInPlace(_ insets: UIEdgeInsets) {
		self = increaseBy(insets)
	}


	var inverse: UIEdgeInsets {
		return UIEdgeInsets(top: -top, left: -left, bottom: -bottom, right: -right)
	}


	var isEmpty: Bool {
		return (top == 0 && left == 0 && bottom == 0 && right == 0)
	}
}



public extension CGRect {

	
	func insetBy(_ insets: UIEdgeInsets) -> CGRect {
		return CGRect(
			left:   left + insets.left,
			top:    top + insets.top,
			width:  width - insets.left - insets.right,
			height: height - insets.top - insets.bottom
		)
	}


	mutating func insetInPlace(_ insets: UIEdgeInsets) {
		self = insetBy(insets)
	}
}



public extension CGSize {

	
	func insetBy(_ insets: UIEdgeInsets) -> CGSize {
		return CGSize(
			width:  width - insets.left - insets.right,
			height: height - insets.top - insets.bottom
		)
	}


	mutating func insetInPlace(_ insets: UIEdgeInsets) {
		self = insetBy(insets)
	}
}

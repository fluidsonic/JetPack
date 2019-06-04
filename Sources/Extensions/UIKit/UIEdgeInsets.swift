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


	@available(*, unavailable, message: "a + b")
	func increaseBy(_ insets: UIEdgeInsets) -> UIEdgeInsets {
		return self + insets
	}


	@available(*, deprecated, message: "insets = insets.increase(by: …)")
	mutating func increaseInPlace(_ insets: UIEdgeInsets) {
		self += insets
	}


	@available(*, unavailable, renamed: "-")
	var inverse: UIEdgeInsets {
		return -self
	}


	var isEmpty: Bool {
		return self == .zero
	}


	static prefix func - (_ insets: UIEdgeInsets) -> UIEdgeInsets {
		return UIEdgeInsets(top: -insets.top, left: -insets.left, bottom: -insets.bottom, right: -insets.right)
	}


	static func + (_ lhs: UIEdgeInsets, _ rhs: UIEdgeInsets) -> UIEdgeInsets {
		return UIEdgeInsets(top: lhs.top + rhs.top, left: lhs.left + rhs.left, bottom: lhs.bottom + rhs.bottom, right: lhs.right + rhs.right)
	}


	static func += (_ lhs: inout UIEdgeInsets, _ rhs: UIEdgeInsets) {
		lhs = lhs + rhs
	}


	static func - (_ lhs: UIEdgeInsets, _ rhs: UIEdgeInsets) -> UIEdgeInsets {
		return UIEdgeInsets(top: lhs.top - rhs.top, left: lhs.left - rhs.left, bottom: lhs.bottom - rhs.bottom, right: lhs.right - rhs.right)
	}


	static func -= (_ lhs: inout UIEdgeInsets, _ rhs: UIEdgeInsets) {
		lhs = lhs - rhs
	}
}



public extension CGRect {

	@available(*, unavailable, renamed: "inset(by:)")
	func insetBy(_ insets: UIEdgeInsets) -> CGRect {
		return inset(by: insets)
	}


	@available(*, deprecated, message: "rect = rect.inset(by: …)")
	mutating func insetInPlace(_ insets: UIEdgeInsets) {
		self = inset(by: insets)
	}
}



public extension CGSize {

	func inset(by insets: UIEdgeInsets) -> CGSize {
		return CGSize(
			width:  width - insets.left - insets.right,
			height: height - insets.top - insets.bottom
		)
	}


	@available(*, unavailable, renamed: "inset(by:)")
	func insetBy(_ insets: UIEdgeInsets) -> CGSize {
		return inset(by: insets)
	}


	@available(*, deprecated, message: "size = size.inset(by: …)")
	mutating func insetInPlace(_ insets: UIEdgeInsets) {
		self = inset(by: insets)
	}
}

import UIKit


public extension UIEdgeInsets {

	public static let zeroInsets = UIEdgeInsets()


	public init() {
		self.init(top: 0, left: 0, bottom: 0, right: 0)
	}
}


extension UIEdgeInsets: Equatable {}


public func == (a: UIEdgeInsets, b: UIEdgeInsets) -> Bool {
	return (a.top == b.top && a.left == b.left && a.bottom == b.bottom && a.right == b.right)
}

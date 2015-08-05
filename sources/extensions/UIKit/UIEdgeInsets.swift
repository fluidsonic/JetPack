import UIKit


public extension UIEdgeInsets {

	public static let zeroInsets = UIEdgeInsets()


	public init(all: CGFloat) {
		self.init(top: all, left: all, bottom: all, right: all)
	}
}

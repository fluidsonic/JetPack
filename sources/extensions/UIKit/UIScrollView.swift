import UIKit


public extension UIScrollView {

	@nonobjc
	public var maximumContentOffset: CGPoint {
		let size = self.bounds.size
		let contentInset = self.contentInset
		let contentSize = self.contentSize

		return CGPoint(
			left: max(contentSize.width + contentInset.right - size.width, 0),
			top:  max(contentSize.height + contentInset.bottom - size.height, 0)
		)
	}


	@nonobjc
	public var minimumContentOffset: CGPoint {
		let contentInset = self.contentInset

		return CGPoint(left: -contentInset.left, top: -contentInset.top)
	}
}

import UIKit


public extension UIScrollView {

	@nonobjc
	public var contentFrame: CGRect {
		return CGRect(size: contentSize)
	}


	@nonobjc
	public var maximumContentOffset: CGPoint {
		let size = self.bounds.size
		let contentInset = self.contentInset
		let contentSize = self.contentSize

		return CGPoint(
			left: max(contentSize.width + contentInset.right - size.width, -contentInset.left),
			top:  max(contentSize.height + contentInset.bottom - size.height, -contentInset.top)
		)
	}


	@nonobjc
	public var minimumContentOffset: CGPoint {
		let contentInset = self.contentInset

		return CGPoint(left: -contentInset.left, top: -contentInset.top)
	}


	@nonobjc
	public func setContentInset(_ contentInset: UIEdgeInsets, maintainingVisualContentOffset maintainsVisualContentOffset: Bool) {
		let oldContentInsets = self.contentInset
		let newContentInsets = contentInset
		guard newContentInsets != oldContentInsets else {
			return
		}
		guard maintainsVisualContentOffset else {
			self.contentInset = newContentInsets
			return
		}

		let oldContentOffset = contentOffset
		self.contentInset = newContentInsets

		let newContentOffset = oldContentOffset
			.offsetBy(dy: oldContentInsets.top - newContentInsets.top)
			.clamp(min: minimumContentOffset, max: maximumContentOffset)
		guard newContentOffset != oldContentOffset else {
			return
		}

		self.contentOffset = newContentOffset
	}
}


extension UIScrollView: UIGestureRecognizerDelegate {}

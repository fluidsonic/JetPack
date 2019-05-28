import UIKit


public extension UIScrollView {

	@nonobjc
	var contentFrame: CGRect {
		return CGRect(size: contentSize)
	}


	@objc(JetPack_maximumContentOffset)
	var maximumContentOffset: CGPoint {
		let size = self.bounds.size
		let contentInset = self.contentInset
		let contentSize = self.contentSize

		return CGPoint(
			left: max(contentSize.width + contentInset.right - size.width, -contentInset.left),
			top:  max(contentSize.height + contentInset.bottom - size.height, -contentInset.top)
		)
	}


	@nonobjc
	var minimumContentOffset: CGPoint {
		let contentInset = self.contentInset

		return CGPoint(left: -contentInset.left, top: -contentInset.top)
	}


	// TODO The way changing the content inset affects the content offset is weird.
	// This should be re-thought and well-tested.
	@nonobjc
	func setContentInset(_ contentInset: UIEdgeInsets, maintainingVisualContentOffset maintainsVisualContentOffset: Bool) {
		let oldContentInsets = self.contentInset
		let newContentInsets = contentInset
		guard newContentInsets != oldContentInsets else {
			return
		}

		let contentOffsetWasMinimum = (contentOffset == minimumContentOffset)

		self.contentInset = newContentInsets

		if contentOffsetWasMinimum {
			contentOffset = minimumContentOffset
		}
	}
}


extension UIScrollView: UIGestureRecognizerDelegate {}

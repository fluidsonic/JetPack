import UIKit


public extension UITableView {

	@nonobjc
	public func scrollRowAtIndexPathToVisible(indexPath: NSIndexPath, insets: UIEdgeInsets = .zero, animated: Bool = false) -> Bool {
		let contentSize = self.contentSize

		var rect = rectForRowAtIndexPath(indexPath).insetBy(insets.inverse)
		rect.left = rect.left.clamp(min: 0, max: max(contentSize.width - rect.width, 0))
		rect.top = rect.top.clamp(min: 0, max: max(contentSize.height - rect.height, 0))

		guard !bounds.insetBy(contentInset).contains(rect) else {
			return false
		}

		scrollRectToVisible(rect, animated: animated)
		return true
	}


	@nonobjc
	public func setContentInset(contentInset: UIEdgeInsets, maintainingVisualContentOffset maintainsVisualContentOffset: Bool) {
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

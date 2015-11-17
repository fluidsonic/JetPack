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
}

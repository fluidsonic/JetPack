import UIKit


public extension UITableView {

	@nonobjc
	public func scrollRowAtIndexPathToVisible(indexPath: NSIndexPath, insets: UIEdgeInsets = .zero, animated: Bool = false) {
		let contentSize = self.contentSize

		var rect = rectForRowAtIndexPath(indexPath).insetBy(insets.inverse)
		rect.left = rect.left.clamp(min: 0, max: max(contentSize.width - rect.width, 0))
		rect.top = rect.top.clamp(min: 0, max: max(contentSize.height - rect.height, 0))

		scrollRectToVisible(rect, animated: animated)
	}
}

import UIKit


public extension UITableView {

	private struct AssociatedKeys {
		private static var indexPathForCurrentHeightComputation = UInt8()
	}


	@nonobjc
	internal private(set) var indexPathForCurrentHeightComputation: NSIndexPath? {
		get { return objc_getAssociatedObject(self, &AssociatedKeys.indexPathForCurrentHeightComputation) as? NSIndexPath }
		set { objc_setAssociatedObject(self, &AssociatedKeys.indexPathForCurrentHeightComputation, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}


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
	internal static func UITableView_setUp() {
		// yep, private API necessary :(
		// UIKit doesn't let us properly implement our own sizeThatFits() in UITableViewCell subclasses because we're unable to determine the correct size of .contentView
		swizzleMethodInType(self, fromSelector: obfuscatedSelector("_", "height", "For", "Cell:", "at", "Index", "Path:"), toSelector: "JetPack_computeHeightForCell:atIndexPath:")
	}


	@objc(JetPack_computeHeightForCell:atIndexPath:)
	private dynamic func swizzled_computeHeightForCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) -> CGFloat {
		indexPathForCurrentHeightComputation = indexPath
		let height = swizzled_computeHeightForCell(cell, atIndexPath: indexPath)
		indexPathForCurrentHeightComputation = nil

		return height
	}
}

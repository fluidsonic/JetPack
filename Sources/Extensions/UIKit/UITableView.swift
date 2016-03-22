import UIKit


public extension UITableView {

	private struct AssociatedKeys {
		private static var indexPathForCurrentHeightComputation = UInt8()
	}


	@nonobjc
	public func deselectAllRowsAnimated(animated: Bool) {
		for indexPath in indexPathsForSelectedRows ?? [] {
			deselectRowAtIndexPath(indexPath, animated: animated)
		}
	}


	@nonobjc
	public var firstIndexPath: NSIndexPath? {
		let sectionCount = numberOfSections
		guard sectionCount > 0 else {
			return nil
		}

		for section in 0 ..< sectionCount {
			let rowCount = numberOfRowsInSection(section)
			guard rowCount > 0 else {
				continue
			}

			return NSIndexPath(forRow: 0, inSection: section)
		}

		return nil
	}


	@nonobjc
	internal private(set) var indexPathForCurrentHeightComputation: NSIndexPath? {
		get { return objc_getAssociatedObject(self, &AssociatedKeys.indexPathForCurrentHeightComputation) as? NSIndexPath }
		set { objc_setAssociatedObject(self, &AssociatedKeys.indexPathForCurrentHeightComputation, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}


	@nonobjc
	public var lastIndexPath: NSIndexPath? {
		let sectionCount = numberOfSections
		guard sectionCount > 0 else {
			return nil
		}

		for section in (0 ..< sectionCount).reverse() {
			let rowCount = numberOfRowsInSection(section)
			guard rowCount > 0 else {
				continue
			}

			return NSIndexPath(forRow: rowCount - 1, inSection: section)
		}

		return nil
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
		swizzleMethodInType(self, fromSelector: obfuscatedSelector("_", "height", "For", "Cell:", "at", "Index", "Path:"), toSelector: #selector(swizzled_computeHeightForCell(_:atIndexPath:)))
	}


	@objc(JetPack_computeHeightForCell:atIndexPath:)
	private dynamic func swizzled_computeHeightForCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) -> CGFloat {
		indexPathForCurrentHeightComputation = indexPath
		let height = swizzled_computeHeightForCell(cell, atIndexPath: indexPath)
		indexPathForCurrentHeightComputation = nil

		return height
	}
}

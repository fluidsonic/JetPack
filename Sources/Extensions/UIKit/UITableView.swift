import UIKit


public extension UITableView {

	fileprivate struct AssociatedKeys {
		fileprivate static var indexPathForCurrentHeightComputation = UInt8()
	}


	@nonobjc
	func deselectAllRowsAnimated(_ animated: Bool) {
		for indexPath in indexPathsForSelectedRows ?? [] {
			deselectRow(at: indexPath, animated: animated)
		}
	}


	@nonobjc
	var firstIndexPath: IndexPath? {
		let sectionCount = numberOfSections
		guard sectionCount > 0 else {
			return nil
		}

		for section in 0 ..< sectionCount {
			let rowCount = numberOfRows(inSection: section)
			guard rowCount > 0 else {
				continue
			}

			return IndexPath(row: 0, section: section)
		}

		return nil
	}


	@nonobjc
	var floatsHeaderAndFooterViews: Bool {
		get { return redirected_headerAndFooterViewsFloat() }
		set { redirected_setHeaderAndFooterViewsFloat(newValue) }
	}


	@nonobjc
	internal fileprivate(set) var indexPathForCurrentHeightComputation: IndexPath? {
		get { return objc_getAssociatedObject(self, &AssociatedKeys.indexPathForCurrentHeightComputation) as? IndexPath }
		set { objc_setAssociatedObject(self, &AssociatedKeys.indexPathForCurrentHeightComputation, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}


	@nonobjc
	var lastIndexPath: IndexPath? {
		let sectionCount = numberOfSections
		guard sectionCount > 0 else {
			return nil
		}

		for section in (0 ..< sectionCount).reversed() {
			let rowCount = numberOfRows(inSection: section)
			guard rowCount > 0 else {
				continue
			}

			return IndexPath(row: rowCount - 1, section: section)
		}

		return nil
	}


	override var maximumContentOffset: CGPoint {
		let numberOfSections = self.numberOfSections
		guard numberOfSections > 0 else {
			return super.maximumContentOffset
		}

		// we cannot rely on contentSize while update animations are in-flight, so we use ret(forSection:) instead

		let lastSectionRect = rect(forSection: numberOfSections - 1)
		let size = self.bounds.size
		let contentInset = self.contentInset

		return CGPoint(
			left: 0,
			top:  max(lastSectionRect.bottom + contentInset.bottom - size.height, -contentInset.top)
		)
	}


	@objc(JetPack_floatsHeaderAndFooterViews)
	fileprivate dynamic func redirected_headerAndFooterViewsFloat() -> Bool {
		// called when private function is no longer available
		return true
	}


	@objc(JetPack_setFloatsHeaderAndFooterViews:)
	fileprivate dynamic func redirected_setHeaderAndFooterViewsFloat(_ headerAndFooterViewsFloat: Bool) {
		// called when private function is no longer available
	}


	@nonobjc
	func scrollRowAtIndexPathToVisible(_ indexPath: IndexPath, insets: UIEdgeInsets = .zero, animated: Bool = false) -> Bool {
		let contentSize = self.contentSize

		var rect = rectForRow(at: indexPath).insetBy(insets.inverse)
		rect.left = rect.left.coerced(in: 0 ... max(contentSize.width - rect.width, 0))
		rect.top = rect.top.coerced(in: 0 ... max(contentSize.height - rect.height, 0))

		guard !bounds.insetBy(contentInset).contains(rect) else {
			return false
		}

		scrollRectToVisible(rect, animated: animated)
		return true
	}


	@objc(JetPack_computeHeightForCell:atIndexPath:)
	fileprivate dynamic func swizzled_computeHeightForCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath) -> CGFloat {
		indexPathForCurrentHeightComputation = indexPath
		let height = swizzled_computeHeightForCell(cell, atIndexPath: indexPath)
		indexPathForCurrentHeightComputation = nil

		return height
	}
}


@objc(_JetPack_Extensions_UIKit_UITableView_Initialization)
private class StaticInitialization: NSObject, StaticInitializable {

	static func staticInitialize() {
		// yep, private API necessary :(

		redirectMethod(in: UITableView.self, from: #selector(UITableView.redirected_headerAndFooterViewsFloat), to: obfuscatedSelector("_header", "And", "Footer", "Views", "Float"))

		redirectMethod(in: UITableView.self, from: #selector(UITableView.redirected_setHeaderAndFooterViewsFloat), to: obfuscatedSelector("_set", "Header", "And", "Footer", "Views" ,"Float:"))

		// UIKit doesn't let us properly implement our own sizeThatFits() in UITableViewCell subclasses because we're unable to determine the correct size of .contentView
		swizzleMethod(in: UITableView.self, from: obfuscatedSelector("_", "height", "For", "Cell:", "at", "Index", "Path:"), to: #selector(UITableView.swizzled_computeHeightForCell(_:atIndexPath:)))
	}
}

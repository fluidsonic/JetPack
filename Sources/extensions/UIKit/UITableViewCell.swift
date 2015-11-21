import UIKit

/*
	UITableViewCell's default layout is a bit inconsistent.
	By default UITableView's cells are 44 point high (with and without separator).
	But UITableViewCell's sizeThatFits(_:) returns a cell height of 44 (without separator) and 45 (with separator).
	So as soon as you set the UITableView's .estimatedRowHeight the cells will become 1 point higher if they have a separator because sizeThatFits(_:) will now be used.
	The separator is 0.5 point high on 2x scale and 0.3~ point high on 3x scale - yet sizeThatFits(_:) always returns an additional 1 point.
*/


public extension UITableViewCell {

	@objc(JetPack_contentHeightThatFitsWidth:defaultHeight:)
	internal func contentHeightThatFitsWidth(width: CGFloat, defaultHeight: CGFloat) -> CGFloat {
		return defaultHeight
	}


	@nonobjc
	private func fallbackSizeThatFitsSize(maximumSize: CGSize) -> CGSize {
		// Private API has changed :(
		// So in the worst case we have to provide an acceptable fallback until the issue is resolved.
		// @Apple, please make this easier to implement! We don't want to make our own UITableView just to implement manual layouting of UITableViewCells correctly…

		layoutIfNeeded()
		let contentFrame = contentView.frame

		return sizeThatFitsContentWidth(contentFrame.width, cellWidth: maximumSize.width, defaultContentHeight: contentFrame.height)
	}


	@nonobjc
	internal final func improvedSizeThatFitsSize(maximumSize: CGSize) -> CGSize {
		guard let layoutManager = private_layoutManager where layoutManager.respondsToSelector("JetPack_contentFrameForCell:editing:showingDeleteConfirmation:width:") else {
			// private property -[UITableViewCell layoutManager] was renamed, removed or changed type
			return fallbackSizeThatFitsSize(maximumSize)
		}

		var contentFrame = layoutManager.private_contentFrameForCell(self, editing: editing, showingDeleteConfirmation: showingDeleteConfirmation, width: maximumSize.width)
		guard !contentFrame.isNull else {
			// Private method -[UITableViewCellLayoutManager _contentRectForCell:forEditingState:showingDeleteConfirmation:rowWidth:] was renamed or removed
			return fallbackSizeThatFitsSize(maximumSize)
		}

		// finally we know how wide .contentView will be!
		return sizeThatFitsContentWidth(contentFrame.width, cellWidth: maximumSize.width, defaultContentHeight: contentFrame.height)
	}


	@objc(JetPack_layoutManager)
	private dynamic var private_layoutManager: LayoutManager? {
		// called only when private property was renamed or removed
		return nil
	}


	@objc(JetPack_separatorStyle)
	private dynamic var private_separatorStyle: UITableViewCellSeparatorStyle {
		// called only when private property was renamed or removed
		return .SingleLine
	}


	@nonobjc
	internal static func UITableViewCell_setUp() {
		// yep, private API necessary :(
		// UIKit doesn't let us properly implement our own sizeThatFits() in UITableViewCell subclasses because we're unable to determine the correct size of .contentView
		redirectMethodInType(self, fromSelector: "JetPack_layoutManager", toSelector: obfuscatedSelector("layout", "Manager"))
		redirectMethodInType(self, fromSelector: "JetPack_separatorStyle", toSelector: obfuscatedSelector("separator", "Style"))

		LayoutManager.setUp()
	}


	@nonobjc
	private func sizeThatFitsContentWidth(contentWidth: CGFloat, cellWidth: CGFloat, defaultContentHeight: CGFloat) -> CGSize {
		var cellHeight = contentHeightThatFitsWidth(contentWidth, defaultHeight: defaultContentHeight)
		if private_separatorStyle != .None {
			cellHeight += pointsForPixels(1)
		}
		cellHeight = ceilToGrid(cellHeight)

		return CGSize(width: cellWidth, height: cellHeight)
	}
}



private final class LayoutManager: NSObject {

	@objc(JetPack_contentFrameForCell:editing:showingDeleteConfirmation:width:)
	private dynamic func private_contentFrameForCell(cell: UITableViewCell, editing: Bool, showingDeleteConfirmation: Bool, width: CGFloat) -> CGRect {
		// called only when private method was renamed or removed
		return .null
	}


	@nonobjc
	private static func setUp() {
		// yep, private API necessary :(
		// UIKit doesn't let us properly implement our own sizeThatFits() in UITableViewCell subclasses because we're unable to determine the correct size of .contentView

		guard let layoutManagerType = NSClassFromString(["UITableView", "Cell", "Layout", "Manager"].joinWithSeparator("")) else {
			log("Integration with UITableViewCell's layout system does not work anymore.\nReport this at https://github.com/fluidsonic/JetPack/issues?q=contentHeightThatFitsWidth+broken")
			return
		}

		copyMethodWithSelector("JetPack_contentFrameForCell:editing:showingDeleteConfirmation:width:", fromType: self, toType: layoutManagerType)
		redirectMethodInType(layoutManagerType,
			fromSelector: "JetPack_contentFrameForCell:editing:showingDeleteConfirmation:width:",
			toSelector:   obfuscatedSelector("_", "content", "Rect", "For", "Cell:", "for", "Editing", "State:", "showingDeleteConfirmation:", "row", "Width:")
		)
	}
}

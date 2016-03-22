import UIKit

/*
	UITableViewCell's default layout is a bit inconsistent.
	By default UITableView's cells are 44 point high (with and without separator).
	But UITableViewCell's sizeThatFits(_:) returns a cell height of 44 (without separator) and 45 (with separator).
	So as soon as you set the UITableView's .estimatedRowHeight the cells will become 1 point higher if they have a separator because sizeThatFits(_:) will now be used.
	The separator is 0.5 point high on 2x scale and 0.3~ point high on 3x scale - yet sizeThatFits(_:) always returns an additional 1 point.
*/


public extension UITableViewCell {

	private struct AssociatedKeys {
		private static var predictedConfiguration = UInt8()
	}


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
		guard let layoutManager = private_layoutManager where layoutManager.respondsToSelector(#selector(LayoutManager.private_contentFrameForCell(_:editing:showingDeleteConfirmation:width:))) else {
			// private property -[UITableViewCell layoutManager] was renamed, removed or changed type
			return fallbackSizeThatFitsSize(maximumSize)
		}

		let editing: Bool
		if let tableView = (superview as? UITableView) ?? (superview?.superview as? UITableView), let indexPath = tableView.indexPathForCurrentHeightComputation {
			editing = tableView.editing

			predictedConfiguration = PredictedConfiguration(
				editing:                   editing,
				editingStyle:              tableView.delegate?.tableView?(tableView, editingStyleForRowAtIndexPath: indexPath) ?? .Delete,
				shouldIndentWhileEditing:  tableView.delegate?.tableView?(tableView, shouldIndentWhileEditingRowAtIndexPath: indexPath) ?? true,
				showsReorderControl:       showsReorderControl && (tableView.dataSource?.tableView?(tableView, canMoveRowAtIndexPath: indexPath) ?? false)
			)
		}
		else {
			editing = self.swizzled_editing

			predictedConfiguration = nil
		}

		var contentFrame = layoutManager.private_contentFrameForCell(self, editing: editing, showingDeleteConfirmation: showingDeleteConfirmation, width: maximumSize.width)
		predictedConfiguration = nil

		guard !contentFrame.isNull else {
			// Private method -[UITableViewCellLayoutManager _contentRectForCell:forEditingState:showingDeleteConfirmation:rowWidth:] was renamed or removed
			return fallbackSizeThatFitsSize(maximumSize)
		}

		// finally we know how wide .contentView will be!
		return sizeThatFitsContentWidth(contentFrame.width, cellWidth: maximumSize.width, defaultContentHeight: contentFrame.height)
	}


	@nonobjc
	private var predictedConfiguration: PredictedConfiguration? {
		get { return (objc_getAssociatedObject(self, &AssociatedKeys.predictedConfiguration) as? StrongReference<PredictedConfiguration>)?.target }
		set { objc_setAssociatedObject(self, &AssociatedKeys.predictedConfiguration, newValue != nil ? StrongReference(newValue!) : nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
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
		swizzleMethodInType(self, fromSelector: Selector("isEditing"),                toSelector: Selector("JetPack_isEditing"))
		swizzleMethodInType(self, fromSelector: Selector("editingStyle"),             toSelector: Selector("JetPack_editingStyle"))
		swizzleMethodInType(self, fromSelector: Selector("shouldIndentWhileEditing"), toSelector: Selector("JetPack_shouldIndentWhileEditing"))
		swizzleMethodInType(self, fromSelector: Selector("showsReorderControl"),      toSelector: Selector("JetPack_showsReorderControl"))

		// yep, private API necessary :(
		// UIKit doesn't let us properly implement our own sizeThatFits() in UITableViewCell subclasses because we're unable to determine the correct size of .contentView
		redirectMethodInType(self, fromSelector: Selector("JetPack_layoutManager"),  toSelector: obfuscatedSelector("layout", "Manager"))
		redirectMethodInType(self, fromSelector: Selector("JetPack_separatorStyle"), toSelector: obfuscatedSelector("separator", "Style"))

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


	@objc(JetPack_isEditing)
	private dynamic var swizzled_editing: Bool {
		if let predictedConfiguration = predictedConfiguration {
			return predictedConfiguration.editing
		}

		return self.swizzled_editing
	}


	@objc(JetPack_editingStyle)
	private dynamic var swizzled_editingStyle: UITableViewCellEditingStyle {
		if let predictedConfiguration = predictedConfiguration {
			return predictedConfiguration.editingStyle
		}

		return self.swizzled_editingStyle
	}


	@objc(JetPack_shouldIndentWhileEditing)
	private dynamic var swizzled_shouldIndentWhileEditing: Bool {
		if let predictedConfiguration = predictedConfiguration {
			return predictedConfiguration.shouldIndentWhileEditing
		}

		return self.swizzled_shouldIndentWhileEditing
	}


	@objc(JetPack_showsReorderControl)
	private dynamic var swizzled_showsReorderControl: Bool {
		if let predictedConfiguration = predictedConfiguration {
			return predictedConfiguration.showsReorderControl
		}

		return self.swizzled_showsReorderControl
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

		copyMethodWithSelector(#selector(private_contentFrameForCell(_:editing:showingDeleteConfirmation:width:)), fromType: self, toType: layoutManagerType)
		redirectMethodInType(layoutManagerType,
			fromSelector: #selector(private_contentFrameForCell(_:editing:showingDeleteConfirmation:width:)),
			toSelector:   obfuscatedSelector("_", "content", "Rect", "For", "Cell:", "for", "Editing", "State:", "showingDeleteConfirmation:", "row", "Width:")
		)
	}
}


private struct PredictedConfiguration {

	private var editing: Bool
	private var editingStyle: UITableViewCellEditingStyle
	private var shouldIndentWhileEditing: Bool
	private var showsReorderControl: Bool
}



extension UITableViewCellEditingStyle: CustomDebugStringConvertible {

	public var debugDescription: String {
		return "UITableViewCellEditingStyle.\(description)"
	}
}


extension UITableViewCellEditingStyle: CustomStringConvertible {

	public var description: String {
		switch self {
		case .Delete: return "Delete"
		case .Insert: return "Insert"
		case .None:   return "None"
		}
	}
}

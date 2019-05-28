import UIKit

/*
	UITableViewCell's default layout is a bit inconsistent.
	By default UITableView's cells are 44 point high (with and without separator).
	But UITableViewCell's sizeThatFits(_:) returns a cell height of 44 (without separator) and 45 (with separator).
	So as soon as you set the UITableView's .estimatedRowHeight the cells will become 1 point higher if they have a separator because sizeThatFits(_:) will now be used.
	The separator is 0.5 point high on 2x scale and 0.3~ point high on 3x scale - yet sizeThatFits(_:) always returns an additional 1 point.
*/


public extension UITableViewCell {

	fileprivate struct AssociatedKeys {
		fileprivate static var predictedConfiguration = UInt8()
	}


	@objc(JetPack_contentHeightThatFitsWidth:defaultHeight:)
	internal func contentHeightThatFitsWidth(_ width: CGFloat, defaultHeight: CGFloat) -> CGFloat {
		return defaultHeight
	}


	@nonobjc
	fileprivate func fallbackSizeThatFitsSize(_ maximumSize: CGSize) -> CGSize {
		// Private API has changed :(
		// So in the worst case we have to provide an acceptable fallback until the issue is resolved.
		// @Apple, please make this easier to implement! We don't want to make our own UITableView just to implement manual layouting of UITableViewCells correctly…

		layoutIfNeeded()
		let contentFrame = contentView.frame

		return sizeThatFitsContentWidth(contentFrame.width, cellWidth: maximumSize.width, defaultContentHeight: contentFrame.height)
	}


	@nonobjc
	internal final func improvedSizeThatFitsSize(_ maximumSize: CGSize) -> CGSize {
		guard let layoutManager = private_layoutManager, layoutManager.responds(to: #selector(LayoutManager.private_contentFrameForCell(_:editing:showingDeleteConfirmation:width:))) else {
			// private property -[UITableViewCell layoutManager] was renamed, removed or changed type
			return fallbackSizeThatFitsSize(maximumSize)
		}

		let editing: Bool
		if let tableView = (superview as? UITableView) ?? (superview?.superview as? UITableView), let indexPath = tableView.indexPathForCurrentHeightComputation {
			editing = tableView.isEditing

			predictedConfiguration = PredictedConfiguration(
				editing:                   editing,
				editingStyle:              tableView.delegate?.tableView?(tableView, editingStyleForRowAt: indexPath as IndexPath) ?? .delete,
				shouldIndentWhileEditing:  tableView.delegate?.tableView?(tableView, shouldIndentWhileEditingRowAt: indexPath as IndexPath) ?? true,
				showsReorderControl:       showsReorderControl && (tableView.dataSource?.tableView?(tableView, canMoveRowAt: indexPath as IndexPath) ?? false)
			)
		}
		else {
			editing = self.swizzled_isEditing

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
	fileprivate var predictedConfiguration: PredictedConfiguration? {
		get { return (objc_getAssociatedObject(self, &AssociatedKeys.predictedConfiguration) as? StrongReference<PredictedConfiguration>)?.value }
		set { objc_setAssociatedObject(self, &AssociatedKeys.predictedConfiguration, newValue != nil ? StrongReference(newValue!) : nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}


	@objc(JetPack_layoutManager)
	fileprivate dynamic var private_layoutManager: LayoutManager? {
		// called only when private property was renamed or removed
		return nil
	}


	@objc(JetPack_separatorStyle)
	fileprivate dynamic var private_separatorStyle: UITableViewCell.SeparatorStyle {
		// called only when private property was renamed or removed
		return .singleLine
	}


	@nonobjc
	fileprivate func sizeThatFitsContentWidth(_ contentWidth: CGFloat, cellWidth: CGFloat, defaultContentHeight: CGFloat) -> CGSize {
		var cellHeight = contentHeightThatFitsWidth(contentWidth, defaultHeight: defaultContentHeight)
		if private_separatorStyle != .none {
			cellHeight += pointsForPixels(1)
		}
		cellHeight = ceilToGrid(cellHeight)

		return CGSize(width: cellWidth, height: cellHeight)
	}


	@objc(JetPack_editingStyle)
	fileprivate dynamic var swizzled_editingStyle: UITableViewCell.EditingStyle {
		if let predictedConfiguration = predictedConfiguration {
			return predictedConfiguration.editingStyle
		}

		return self.swizzled_editingStyle
	}


	@objc(JetPack_isEditing)
	fileprivate dynamic var swizzled_isEditing: Bool {
		if let predictedConfiguration = predictedConfiguration {
			return predictedConfiguration.editing
		}

		return self.swizzled_isEditing
	}


	@objc(JetPack_shouldIndentWhileEditing)
	fileprivate dynamic var swizzled_shouldIndentWhileEditing: Bool {
		if let predictedConfiguration = predictedConfiguration {
			return predictedConfiguration.shouldIndentWhileEditing
		}

		return self.swizzled_shouldIndentWhileEditing
	}


	@objc(JetPack_showsReorderControl)
	fileprivate dynamic var swizzled_showsReorderControl: Bool {
		if let predictedConfiguration = predictedConfiguration {
			return predictedConfiguration.showsReorderControl
		}

		return self.swizzled_showsReorderControl
	}
}



private final class LayoutManager: NSObject {

	@objc(JetPack_contentFrameForCell:editing:showingDeleteConfirmation:width:)
	fileprivate dynamic func private_contentFrameForCell(_ cell: UITableViewCell, editing: Bool, showingDeleteConfirmation: Bool, width: CGFloat) -> CGRect {
		// called only when private method was renamed or removed
		return .null
	}


	@nonobjc
	fileprivate static func setUp() {
		// yep, private API necessary :(
		// UIKit doesn't let us properly implement our own sizeThatFits() in UITableViewCell subclasses because we're unable to determine the correct size of .contentView

		guard let layoutManagerType = NSClassFromString(["UITableView", "Cell", "Layout", "Manager"].joined(separator: "")) else {
			log("Integration with UITableViewCell's layout system does not work anymore.\nReport this at https://github.com/fluidsonic/JetPack/issues?q=contentHeightThatFitsWidth+broken")
			return
		}

		copyMethod(selector: #selector(private_contentFrameForCell(_:editing:showingDeleteConfirmation:width:)), from: self, to: layoutManagerType)
		redirectMethod(in: layoutManagerType,
			from: #selector(private_contentFrameForCell(_:editing:showingDeleteConfirmation:width:)),
			to:   obfuscatedSelector("_", "content", "Rect", "For", "Cell:", "for", "Editing", "State:", "showingDeleteConfirmation:", "row", "Width:")
		)
	}
}


private struct PredictedConfiguration {

	fileprivate var editing: Bool
	fileprivate var editingStyle: UITableViewCell.EditingStyle
	fileprivate var shouldIndentWhileEditing: Bool
	fileprivate var showsReorderControl: Bool
}



extension UITableViewCell.EditingStyle: CustomDebugStringConvertible {

	public var debugDescription: String {
		return "UITableViewCellEditingStyle.\(description)"
	}
}


extension UITableViewCell.EditingStyle: CustomStringConvertible {

	public var description: String {
		switch self {
		case .delete: return "delete"
		case .insert: return "insert"
		case .none:   return "none"

		@unknown default:
			return "rawValue(\(rawValue))"
		}
	}
}


@objc(_JetPack_Extensions_UIKit_UITableViewCell_Initialization)
private class StaticInitialization: NSObject, StaticInitializable {

	static func staticInitialize() {
		swizzleMethod(in: UITableViewCell.self, from: #selector(getter: UITextField.isEditing),                    to: #selector(getter: UITableViewCell.swizzled_isEditing))
		swizzleMethod(in: UITableViewCell.self, from: #selector(getter: UITableViewCell.editingStyle),             to: #selector(getter: UITableViewCell.swizzled_editingStyle))
		swizzleMethod(in: UITableViewCell.self, from: #selector(getter: UITableViewCell.shouldIndentWhileEditing), to: #selector(getter: UITableViewCell.swizzled_shouldIndentWhileEditing))
		swizzleMethod(in: UITableViewCell.self, from: #selector(getter: UITableViewCell.showsReorderControl),      to: #selector(getter: UITableViewCell.swizzled_showsReorderControl))

		// yep, private API necessary :(
		// UIKit doesn't let us properly implement our own sizeThatFits() in UITableViewCell subclasses because we're unable to determine the correct size of .contentView
		redirectMethod(in: UITableViewCell.self, from: #selector(getter: UITableViewCell.private_layoutManager),  to: obfuscatedSelector("layout", "Manager"))
		redirectMethod(in: UITableViewCell.self, from: #selector(getter: UITableViewCell.private_separatorStyle), to: obfuscatedSelector("separator", "Style"))

		LayoutManager.setUp()
	}
}

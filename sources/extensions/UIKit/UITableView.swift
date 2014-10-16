import UIKit

// TODO evil check for iOS >= 8
private let _UITableViewSupportsAutomaticCellHeight = (UIDevice.currentDevice().systemVersion.compare("8", options: NSStringCompareOptions.NumericSearch) != NSComparisonResult.OrderedAscending)


extension UITableView {

	class var supportsAutomaticCellHeight: Bool { return _UITableViewSupportsAutomaticCellHeight }
}

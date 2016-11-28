import Foundation


extension NSIndexPath: Comparable {}


public func < (a: NSIndexPath, b: NSIndexPath) -> Bool {
	return a.compare(b) == .OrderedAscending
}
